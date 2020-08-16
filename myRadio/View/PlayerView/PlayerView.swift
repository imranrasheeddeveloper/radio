//
//  PlayerView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct PlayerView: View {
    // MARK: - PROPERTIES
    let station: Station
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var stationListViewModel: StationListModelView
    
    
    // MARK: - VIEW
    var body: some View {
        ZStack {
            Color.orange.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 10) {
                        
                if (self.playerViewModel.track.artworkURL != nil) {
                    ImageLoaderView(imageUrl: self.playerViewModel.track.artworkURL!)
                        .frame(width: artworkSize, height: artworkSize, alignment: .center)
                } else {
                    ImageLoaderView(imageUrl: station.logo)
                        .frame(width: 100, height: 100, alignment: .center)
                        .modifier(LogoModifier())
                }
                
                Text(self.playerViewModel.track.metaTitle())
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.light)
                
                Text(station.title)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
                
                Text(station.desc)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.light)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                if showBannerLargeAds {
                    BannerLargeVC()
                        .frame(width:  kGADAdSizeLargeBanner.size.width, height: kGADAdSizeLargeBanner.size.height, alignment: .center)
                }
                
                if (showLogoInPlayerScreen) {
                    Image("logo_player")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100)
                }
                    
                    
                HStack(alignment: .center, spacing: 40) {
                    RecordingButton(size: 30)
                    SleepButton(size: 30)
                    ShareButton(station: station, size: 30)
                    FavoritesButton(station: station, size: 30)
                }
                
                HStack(alignment: .center, spacing: 40) {
                    
                    // MARK: Previous Station
                    PreviousButton()
                    
                    // MARK: Pause/Resume
                    if(playerViewModel.isLoading) {
                        ActivityIndicator()
                            .frame(width:90, height: 90)
                            .foregroundColor(Color("ColorOffWhiteAdaptive"))
                    } else {
                        PlayButton()
                    }
                    
                    // MARK: Next Station
                    NextButton()
                }
            } // VStack
            .padding(.vertical, 20)
        }.onAppear(perform: loadNotification) // ZStack
        
    }
    private func loadNotification() {
      //  if !Constant.isItPlaying{
            //self.playerViewModel.togglePlaying()
             //Constant.isItPlaying = true
       // }
       }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(station: sampleStationList[0])
            .environmentObject(PlayerViewModel())
    
    }
   
  
}
