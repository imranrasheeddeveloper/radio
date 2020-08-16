//
//  RecordingsView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI


import SwiftUI

struct RecordingsView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var showPlayer: Bool = false
    @State private var showingActionSheet = false
    @State private var showRecordName = false

    
    // MARK: - VIEW
    var body: some View {
        VStack {
            
            Text("You can record audio in the radio station ")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                if self.playerViewModel.isRecording {
                    self.playerViewModel.stopRecording()
                    self.showRecordName.toggle()
                } else {
                    self.playerViewModel.startRecording()
                }
            }) {
                if(playerViewModel.isRecording) {
                    MicrophoneAnimationView()
                } else {
                    MicrophoneView()
                }
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showRecordName) {
                RecordingNameView()
                    .environmentObject(self.playerViewModel)
            }
            
            NavigationView {
                List {
                    ForEach(self.playerViewModel.recordings, id: \.self) { recording in
                        HStack {
                            Button(action: {
                                self.playerViewModel.stopPlaying()
                                self.showPlayer.toggle()
                            }) {
                                HStack {
                                    Text("\(recording.lastPathComponent)")
                                    Spacer()
                                    Image(systemName: "play.circle")
                                        .imageScale(.large)
                                }
                            }.sheet(isPresented: self.$showPlayer) {
                                RecordingPlayerView(audioUrl: recording)
                            }
                        }
                    } // ForEach
                    .onDelete(perform: delete)
                } // List
                .navigationBarTitle("Recordings")
                .navigationBarItems(trailing: EditButton())
            } // NavigationView
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(playerViewModel.recordings[index])
        }
        playerViewModel.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

// MARK: - PREVIEW
struct RecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsView()
    }
}
