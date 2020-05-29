//
//  PlayerView.swift
//  myRadio
//
//  Created by mt on 24.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    // MARK: - PROPERTIES
    let station: Station
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var stationListViewModel: StationListModelView
    
    // MARK: - VIEW
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: 20) {
                        
                        ImageLoaderView(imageUrl: station.logo)
                            .frame(width: 140, height: 140, alignment: .center)
                            .modifier(LogoModifier())
                        
                        Text(station.title)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .multilineTextAlignment(.center)
                        
                        GenresView(genres: station.genres)
                
                        Text(station.desc)
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.light)
                            .padding(.horizontal, 10)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        HStack(alignment: .center, spacing: 40) {
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
                    }
                    .padding(.vertical, 20)
        }
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(station: sampleStationList[0])
            .environmentObject(PlayerViewModel())
    }
}
