//
//  FavoriteListView.swift
//  myRadio
//
//  Created by mt on 26.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct FavoriteListView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    // MARK: - VIEW
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(favoritesText)
                .modifier(TitleModifier())

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(stationListViewModel.favoriteStationList) { item in
                        Button(action: {
                            self.playerViewModel.streamStation(station: item)
                        }) {
                            FavoriteCellView(station: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
                .padding(.leading, 15)
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
