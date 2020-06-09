//
//  ContentView.swift
//  myRadio
//
//  Created by mt on 23.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var searchText = ""
    @State private var showSleepModal: Bool = false
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    // MARK: - VIEW
    var body: some View {
        ZStack(alignment: .bottom) {

            VStack(alignment: .center, spacing: 0) {
                
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        if(self.playerViewModel.isSleepMode) {
                            self.playerViewModel.disableSleepMode()
                        } else {
                            self.showSleepModal.toggle()
                        }
                    }) {
                        Image(systemName: self.playerViewModel.isSleepMode ? "moon.zzz.fill" : "moon.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding()
                            .foregroundColor(self.playerViewModel.isSleepMode ? Color(UIColor.systemGreen) : Color(UIColor.systemBlue))
                    }.sheet(isPresented: $showSleepModal) {
                        SleepView()
                            .environmentObject(self.playerViewModel)
                    }
                    
                    
                    Spacer()
                    Button(action: {
                        print("Start Recording")
                    }) {
                        Image(systemName: "recordingtape")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding()
                    }
                }
                

                
                Divider()
                
                
                if stationListViewModel.favoriteStationList.count > 0 {
                    FavoriteListView()
                        .padding(.bottom, 10)
                }
                
                Divider()
                
                FilterView()
                    .padding(.bottom, 10)
                
                Divider()


                ScrollView {
                    if self.stationListViewModel.dataIsLoading {
                         ActivityIndicator()
                         .frame(width:30, height: 30)
                         .foregroundColor(.orange)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        SearchBarView(text: $searchText)
                            .padding(.vertical, 10)
                        
                        ForEach(stationList.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) })) { item in
                            Button(action: {
                                self.playerViewModel.streamStation(station: item)
                            }) {
                                StationRowView(station: item)
                                    .padding(.vertical, 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(self.playerViewModel.isStationPlaying(stationId: item.id) ? Color("ColorStationRowShadow") : Color.clear)

                            Divider()
                            
                        }
                    }
                }
                
                if showAds {
                    BannerVC()
                        .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height, alignment: .center)
                }
                
                if(playerViewModel.didSet) {
                    VStack (alignment: .center, spacing: 0, content: {
                        ControllerView()
                            .environmentObject(stationListViewModel)
                    })
                }
                
            } // VStack
        }   // ZStack
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StationListModelView())
            .environmentObject(PlayerViewModel())
    }
}
