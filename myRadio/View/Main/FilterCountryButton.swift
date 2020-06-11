//
//  FilterCountryButton.swift
//  myRadio
//
//  Created by muhammed on 10.06.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI
import FlagKit

struct FilterCountryButton: View {
    // MARK: - PROPERTIES
    var country: String
    @EnvironmentObject var stationListViewModel: StationListModelView
    
    var body: some View {
        Button(action: {
            self.stationListViewModel.toggleCountry(country: self.country)
        }) {
            
            Text(country)
                .font(.system(.footnote, design: .rounded))
                .fontWeight(.light)
                .padding()
                .background(
                    Capsule()
                        .foregroundColor(Color(COLOR_Genre_Background))
                        .opacity(self.stationListViewModel.isCountrySelected(name: country) ? 0.7 : 0.3)
                )
            
            Image(decorative: country, bundle: FlagKit.assetBundle)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterCountryButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterCountryButton(country: "TR")
    }
}
