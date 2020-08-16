//
//  StationRowView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI
import FlagKit

struct StationRowView: View {
    
    // MARK: - PROPERTIES
    let station: Station
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    // MARK: - VIEW
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ImageLoaderView(imageUrl: station.logo)
                .frame(width: 50, height: 50, alignment: .center)
                .modifier(LogoModifier())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(station.title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                
                HStack(alignment: .center, spacing: 5) {
                    Image(decorative: station.countryCode, bundle: FlagKit.assetBundle)
                    GenresView(genres: station.genres)
                }
                
                
                if self.playerViewModel.isPlaying && self.playerViewModel.isStationPlaying(stationId: station.id) {
                    if self.playerViewModel.isLoading {
                        EqualizerStartingAnimationView()
                    } else {
                        EqualizerAnimationView()
                    }
                }
                
                Spacer()
            }
            
            Spacer()
            
            FavoritesButton(station: station, size: 20)
                .overlay(
                    Circle()
                        .stroke(Color(UIColor.systemGray), lineWidth: 2)
                        .opacity(0.2)
                        
                )
                .padding(.trailing, 10)
        }

    }
}

// MARK: - PREVIEW
struct StationRowView_Previews: PreviewProvider {
    static var previews: some View {
        StationRowView(station: sampleStationList[0])
            .previewLayout(.sizeThatFits)
    }
}
