//
//  SingleSectionExampleView.swift
//  GhanaRadio
//
//  Created by Muhammad Imran on 27/08/2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import ASCollectionView_SwiftUI
import SwiftUI

struct SingleSectionExampleView: View {
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var station: Station
    var body: some View
    {
        ASCollectionView(data: stationListViewModel.favoriteStationList, dataID: \.self) { item, _ in
            Color.clear
                .overlay(FavoriteCellView(station: item))
        }
        .layout {
            
            .grid(layoutMode: .adaptive(withMinItemSize: 100),
                  itemSpacing: 5,
                  lineSpacing: 5,
                  itemSize: .absolute(50))
        }
        
    }
}

struct SingleSectionExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSectionExampleView(station: sampleStationList[0])
        .environmentObject(StationListModelView())
        .environmentObject(PlayerViewModel())
    }
}
