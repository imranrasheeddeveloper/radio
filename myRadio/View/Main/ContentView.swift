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
    
    // MARK: - VIEW
    var body: some View {
        ZStack(alignment: .bottom) {

            VStack(alignment: .center, spacing: 0) {
                
                if stationListViewModel.favoriteStationList.count > 0 {
                    FavoriteListView()
                        .padding(.bottom, 10)
                }
                
                Divider()
                
                if self.stationListViewModel.dataIsLoading == false{
                     FilterView()
                        .padding(.bottom, 10)
                }
                
                Divider()

                StationListView()
                
                if showBannerAds {
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
