//
//  StationListView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI
import AVFoundation
struct StationListView: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var searchText = ""
    @State private var showModal: Bool = false
    private var avPlayer: AVPlayer?
    
    private var interstitial:Interstitial = Interstitial()
    @State private var selectedStation: Station?
    @State private var showedInsterstital = false
    

    func playStreaming() {
        self.playerViewModel.streamStation(station: selectedStation!)
        if openFullPlayerViewAuto {
            self.showModal.toggle()
        }
    }
    
    // MARK: - VIEW
    var body: some View {
        ScrollView {
            if self.stationListViewModel.dataIsLoading {
                 ActivityIndicator()
                 .frame(width:30, height: 30)
                 .foregroundColor(.orange)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    
                    SearchBarView(text: $searchText)
                        .padding(.vertical, 10)
                    
                    ForEach(stationList.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) })) { item in
                        
                        Button(action: {
                            self.selectedStation = item
                            
                            // Pause the music if player is active
                            if self.playerViewModel.isPlaying {
                                self.playerViewModel.togglePlaying()
                            }
                            
                            // Check ads config is enabled
                            if(showInsterstitialAds) {
                                if(self.interstitial.showAd()) {
                                    // Don't start streaming until ad dismissed
                                    self.showedInsterstital = true
                                } else {
                                    // If there is no ads, continue to play
                                    self.playStreaming()
                                }
                            } else {
                                // If ads config is disabled continue to play
                                self.playStreaming()
                            }
                            
                        }) {
                            StationRowView(station: item)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(self.playerViewModel.isStationPlaying(stationId: item.id) ? Color("ColorStationRowShadow") : Color.clear)
                        .sheet(isPresented: self.$showModal) {
                            PlayerView(station: self.playerViewModel.station)
                                .environmentObject(self.playerViewModel)
                                .environmentObject(self.stationListViewModel)
                        }

                        Divider()
                    } // ForEach
                } // VStack
            } // if-else
        } // ScrollView
        .onAppear() {
            // Show ads, dont start streaming until ads dismissed
           
            if self.showedInsterstital {
                self.showedInsterstital = false
                self.playStreaming()
            }
        }
    } // body
}

struct StationListView_Previews: PreviewProvider {
    static var previews: some View {
        StationListView()
    }
}
