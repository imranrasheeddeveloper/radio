//
//  FavoriteCellView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct FavoriteCellView: View {
    // MARK: - PROPERTIES
    var station: Station
    
    // MARK: - VIEW
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            
            ImageLoaderView(imageUrl: station.logo)
                .frame(width: 50, height: 50, alignment: .center)
                .modifier(LogoModifier())
            
            Text(station.title)
                .font(.system(.footnote, design: .rounded))
                .frame(width: 80)
                .lineLimit(1)
        }
    }
}

struct FavoriteCellView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCellView(station: sampleStationList[0])
            .previewLayout(.sizeThatFits)
    }
}
