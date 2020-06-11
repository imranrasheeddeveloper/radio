//
//  RecordingsView.swift
//  myRadio
//
//  Created by muhammed on 9.06.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct RecordingsView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var showPlayer: Bool = false
    @State private var showingActionSheet = false
    
    // MARK: - VIEW
    var body: some View {
        VStack {
            Text("Recordings")
                .modifier(TitleModifier())
            
            Text("You can record audio in the radio station ")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                if self.playerViewModel.isRecording {
                    self.playerViewModel.stopRecording()
                } else {
                    self.playerViewModel.startRecording()
                }
            }) {
                Text(playerViewModel.isRecording ? "Stop" : "Start Recording")
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.light)
                    .padding()
                    .background(
                        Capsule()
                            .foregroundColor(Color(COLOR_Genre_Background))
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            List(self.playerViewModel.getAllRecordings(), id: \.self) { recording in
                HStack {
                    Button(action: {
                        self.playerViewModel.stopPlaying()
                        self.showPlayer.toggle()
                    }) {
                        Text("\(recording.lastPathComponent)")
                    }.sheet(isPresented: self.$showPlayer) {
                        RecordingPlayerView(audioUrl: recording)
                    }
                }
            }
        }
    }
}

// MARK: - PREVIEW
struct RecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsView()
    }
}
