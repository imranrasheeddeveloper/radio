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
    @State private var isAnimating = false
    @State private var showProgress = false
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    // MARK: - VIEW
    var body: some View {
        ZStack {
            //Color(hex: "ffe976").edgesIgnoringSafeArea(.all)
           // Color.orange.opacity(0.2).edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .center, spacing: 10) {
                
                if (self.playerViewModel.track.artworkURL != nil) {
                    ImageLoaderView(imageUrl: self.playerViewModel.track.artworkURL!)
                        .frame(width: artworkSize, height: artworkSize, alignment: .center)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.orange, lineWidth: 1))
                        .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                        .animation(self.foreverAnimation)
                        .onAppear {
                            self.isAnimating = true
                            
                    }
                    .onDisappear { self.isAnimating = false }
                } else {
                    ImageLoaderView(imageUrl: station.logo)
                        .frame(width: 200, height: 200 , alignment: .center)
                        .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                        .animation(self.foreverAnimation)
                        .onAppear {
                            self.isAnimating = true
                            
                    }
                    .onDisappear { self.isAnimating = false }
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
                
                //Spacer()
                
//                if showBannerLargeAds {
//                    BannerLargeVC()
//                        .frame(width:  kGADAdSizeLargeBanner.size.width, height: kGADAdSizeLargeBanner.size.height, alignment: .center)
//                }
                
//                if (showLogoInPlayerScreen) {
//                    Image("logo_player")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxHeight: 100)
//                }
                
                
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
                if showBannerLargeAds {
//                    BannerLargeVC()
//                        .frame(width:  kGADAdSizeLargeBanner.size.width, height: kGADAdSizeLargeBanner.size.height, alignment: .center)
                    BannerVC()
                        .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height, alignment: .center)
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
