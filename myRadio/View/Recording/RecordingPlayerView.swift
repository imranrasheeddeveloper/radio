//
//  RecordingPlayerView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation

struct RecordingPlayerView: UIViewControllerRepresentable {
    
    var audioUrl: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
    
        let controller = AVPlayerViewController()
        
        let player = AVPlayer(url: audioUrl)
        player.play()
        controller.player = player
        
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
