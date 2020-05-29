//
//  FavoritesButton.swift
//  myRadio
//
//  Created by mt on 25.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct FavoritesButton: View {
    // MARK: - PROPERTIES
    let station: Station
    let size: CGFloat
    @EnvironmentObject var stationListViewModel: StationListModelView
    
    var imageName: String {
        stationListViewModel.isFavorite(stationID: station.id) ? "heart.fill" : "heart"
    }
    
    var imageColor: Color {
        stationListViewModel.isFavorite(stationID: station.id) ? Color(COLOR_Favorite_Button_Active) : Color(COLOR_Action_Buttons)
    }

    // MARK: - VIEW
    var body: some View {
        Button( action: {
            self.stationListViewModel.toggleFavorite(station: self.station)
        }) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width:size, height: size)
                .foregroundColor(imageColor)
                .padding(10)
        }
    }
}

struct FavoritesButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesButton(station: sampleStationList[0], size: 40)
            .environmentObject(StationListModelView())
            .previewLayout(.sizeThatFits)
    }
}
