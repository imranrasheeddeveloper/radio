//
//  FavoriteListView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct FavoriteListView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    @State private var showModal: Bool = false
    private var interstitial:Interstitial = Interstitial()
    @State private var showedInsterstital = false
    @State private var selectedStation: Station?
    
    func playStreaming() {
        self.playerViewModel.streamStation(station: selectedStation!)
        if openFullPlayerViewAuto {
            self.showModal.toggle()
        }
    }
    // MARK: - VIEW
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(favoritesText)
                .modifier(TitleModifier())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(stationListViewModel.favoriteStationList) { item in
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
                            FavoriteCellView(station: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                            
                        .background(self.playerViewModel.isStationPlaying(stationId: item.id) ? Color("ColorStationRowShadow") : Color.clear)
                        .sheet(isPresented: self.$showModal) {
                            PlayerView(station: self.playerViewModel.station)
                                .environmentObject(self.playerViewModel)
                                .environmentObject(self.stationListViewModel)
                        }
                    }
                }
                .padding(.leading, 15)
            }
        }
        .onAppear() {
            // Show ads, dont start streaming until ads dismissed
            
            if self.showedInsterstital {
                self.showedInsterstital = false
                self.playStreaming()
            }
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
            .environmentObject(StationListModelView())
            .environmentObject(PlayerViewModel())
    }
}
