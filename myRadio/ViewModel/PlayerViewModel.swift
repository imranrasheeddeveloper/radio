//
//  PlayerViewModel.swift
//  myRadio
//
//  Created by mt on 24.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI
import AVFoundation
import MediaPlayer

final class PlayerViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    @Published var didSet: Bool = false
    @Published var isPlaying: Bool = false
    @Published var isLoading: Bool = false
    @Published var station: Station = sampleStationList[0]
    @Published var isSleepMode: Bool = false
    
    
    
    private var workItem: DispatchWorkItem?
    
    private var avPlayer: AVPlayer?
    private var observer: NSKeyValueObservation?
    private var stationIndex: Int = 0
    
    // MARK: - SETUP
    init() {
       setupAVAudioSession()
    }
    
    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            debugPrint("AVAudioSession is Active and Category Playback is set")
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupCommandCenter()
        } catch {
            debugPrint("Error: \(error)")
        }
    }
    
    private func setupCommandCenter() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
           self.avPlayer!.play()
           return .success
        }
        commandCenter.pauseCommand.addTarget {(MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
           self.avPlayer!.pause()
           return .success
        }
        commandCenter.previousTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
           self.streamPreviousStation()
           return .success
        }
        commandCenter.nextTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
           self.streamNextStation()
           return .success
        }
    }

    
    // MARK: - CONTROLLERS
    func isStationPlaying(stationId: String) -> Bool {
        if self.station.id == stationId {
            return true
        }
        return false
    }
    
    func streamStation(station: Station) {
        self.station = station
        self.didSet = true
        
        self.stationIndex = stationList.firstIndex(where: { $0.streamURL == station.streamURL })!
            
        avPlayer = AVPlayer(url: URL(string: station.streamURL)!)
        avPlayer?.play()
        self.isLoading = true
        
        // Set MPNowPlayingInfoCenter title
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: station.title]
        
        // Register as an observer of the player item's timeControlStatus property
        self.observer = avPlayer?.observe(\.timeControlStatus, options:  [.new, .old], changeHandler: { (avPlayer, change) in
            if avPlayer.timeControlStatus == .playing {
                self.isLoading = false
                self.isPlaying = true
            }
        })
    }
    
    func streamNextStation() {
        let totalStation = stationList.count
        let nextIndex = self.stationIndex == totalStation-1 ? 0 : self.stationIndex + 1
        let nextStation = stationList[nextIndex]
        streamStation(station: nextStation)
    }
    
    func streamPreviousStation() {
        let totalStation = stationList.count
        let previousIndex = self.stationIndex == 0 ? totalStation-1 : self.stationIndex - 1
        let previousStation = stationList[previousIndex]
        streamStation(station: previousStation)
    }
    
    func pauseResume() {
        if self.isPlaying {
            avPlayer?.pause()
        } else {
            avPlayer?.play()
        }
        self.isPlaying.toggle()
    }
    
    // MARK: - SLEEP TIMER
    
    func setTimer(countDown: Int) {
        isSleepMode = true
        
        workItem = DispatchWorkItem(block: {
            self.avPlayer?.pause()
            self.isPlaying = false
        })
        let delayInSecond: Double = Double(countDown * 60)
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSecond, execute: workItem!)
    }
    
    func disableSleepMode() {
        isSleepMode = false
        workItem?.cancel()
    }
}



