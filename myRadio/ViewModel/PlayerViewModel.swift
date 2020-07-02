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

final class PlayerViewModel: NSObject, ObservableObject {
    
    
    // MARK: - PROPERTIES
    @Published var didSet: Bool = false
    @Published var isPlaying: Bool = false
    @Published var isLoading: Bool = false
    @Published var station: Station = sampleStationList[0]
    @Published var isSleepMode: Bool = false
    @Published var isRecording: Bool = false
    @Published var track: Track = Track(title: "", artist: "")

    // MARK: Radio Player
    private var avPlayer: AVPlayer?
    private var observer: NSKeyValueObservation?
    private var stationIndex: Int = 0
    
    
    // MARK: Sleep
    private var workItem: DispatchWorkItem?
    
    // MARK: Recording
    var player: AVPlayer!
    var playerItem: CachingPlayerItem!
    var recordingName: String?
    @Published var recordings : [URL] = []

    // MARK: - SETUP
    override init() {
        super.init()
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

    // MARK: - MPNowPlayingInfoCenter (Lock screen)
    func updateLockScreen() {
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()

        nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = track.artist

        if let image = track.artworkImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { size -> UIImage in
                return image
            })
        }
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
        self.track = Track(title:station.title, artist:"")
        
        // Set MPNowPlayingInfoCenter title
        self.updateLockScreen()
        
        self.stationIndex = stationList.firstIndex(where: { $0.streamURL == station.streamURL })!
            
        // Meta data
        let asset = AVAsset(url: URL(string: station.streamURL)!)
        let playerItem = AVPlayerItem(asset: asset)
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: DispatchQueue.main)
        playerItem.add(metadataOutput)
        
        // Player
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer?.play()
        self.isLoading = true
        

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
    
    func togglePlaying() {
        if self.isPlaying {
            avPlayer?.pause()
        } else {
            avPlayer?.play()
        }
        self.isPlaying.toggle()
    }
    
    func stopPlaying() {
        avPlayer?.pause()
        self.isPlaying = false
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
    
    // MARK: - RECORDER
    
    // MARK: - RECORDER
    
    func resetRecordingSetting(){
        playerItem.stopDownloading()
        recordingName = nil
        playerItem = nil
    }
    
    func startRecording(){
        recordingName = "\(Date().toString(dateFormat: "dd-MM-YY HH:mm:ss")).mp3"
        let url = URL(string: station.streamURL)!
        playerItem = CachingPlayerItem(url: url, recordingName: recordingName ?? "default.mp3")
        player = AVPlayer(playerItem: playerItem)
        player.automaticallyWaitsToMinimizeStalling = false
        
        isRecording = true
    }

    func stopRecording(){
        self.saveRecordingWithUserProvidedName(name: recordingName!)
        isRecording = false
        fetchRecordings()
    }
    
    func saveRecordingWithUserProvidedName(name: String){
        playerItem.stopDownloading()
        guard let currentName = recordingName else{return}
        
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentDirectory = URL(fileURLWithPath: path)
            let originPath = documentDirectory.appendingPathComponent(currentName)
            let destinationPath = documentDirectory.appendingPathComponent(name)
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
        } catch {
            print(error)
        }
    }
    
    func discardRecording() {
        
        let fileNameToDelete = recordingName ?? "default.mp3"
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        resetRecordingSetting()
        
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func updateLastRecordName(name: String) {
        
        var invalidCharacters = CharacterSet(charactersIn: ":/")
        invalidCharacters.formUnion(.newlines)
        invalidCharacters.formUnion(.illegalCharacters)
        invalidCharacters.formUnion(.controlCharacters)

        let newFilename = name
            .components(separatedBy: invalidCharacters)
            .joined(separator: "")
        
        if newFilename.count > 0 {
            // Move the last recorded file with the new name
            do {
                let newURL = getDocumentsDirectory().appendingPathComponent("\(newFilename).mp3")
                let lastRecordedURL = getDocumentsDirectory().appendingPathComponent(recordingName!)
                try FileManager.default.moveItem(at: lastRecordedURL, to: newURL)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecordings()
        
    }
    
    func fetchRecordings() {
        do {
           let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           let docs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
           recordings = docs.filter{ $0.pathExtension == "mp3" }
        } catch {
           print(error)
        }
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            print(url)
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecordings()
    }
    
    
}

extension PlayerViewModel: AVPlayerItemMetadataOutputPushDelegate {
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        
        if let item = groups.first?.items.first // make this an AVMetadata item
        {
            let metaTitle = (item.value(forKeyPath: "value")!) as! String
                
            // Split metatitle into asong and artist
            let words = metaTitle.split(separator: "-", maxSplits: 1).map(String.init)

            if words.count > 1 {
                self.track = Track(title: String(words[1].dropFirst()), artist: String(words[0].dropLast()))
            } else {
                self.track = Track(title: metaTitle, artist: "")
            }
            
            // Set MPNowPlayingInfoCenter title
            self.updateLockScreen()
            
            // Fetch artwork album
            FRadioAPI.getArtwork(for: metaTitle, size: Int(artworkSize * 2), completionHandler: { [unowned self] artworlURL in
                
                DispatchQueue.main.async {
                    self.track.artworkURL = artworlURL?.absoluteString
    
                    // Fetch image
                    if self.track.artworkURL != nil {
                        DispatchQueue.global().async {
                            if let url = URL(string:self.track.artworkURL!)  {
                                if let data = try? Data.init(contentsOf: url), let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self.track.artworkImage = image
                                        self.updateLockScreen()
                                    }
                                }
                            }
                        }
                    }
                    
                }
            })
        }
    }
}


