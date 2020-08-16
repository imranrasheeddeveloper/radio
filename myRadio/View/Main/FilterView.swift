//
//  FilterView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    
    @State var isGenresEnabled = false
    @State var isCountriesEnabled = true
    
    // MARK: - VIEW
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .center, spacing: 10) {
                
                Button(action: {
                    self.isGenresEnabled = false
                    self.isCountriesEnabled = true
                }) {
                    Text(countriesText)
                        .modifier(TitleModifier())
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    self.isGenresEnabled = true
                    self.isCountriesEnabled = false
                }) {
                    Text(genresText)
                        .modifier(TitleModifier())
                }
                .buttonStyle(PlainButtonStyle())
                
                
                
                Spacer()
                
                if self.stationListViewModel.showResetFilterButton {
                    Button(action: {
                        self.stationListViewModel.resetFilter()
                    }) {
                        Text(resetFilterText)
                            .font(.system(.footnote, design: .rounded))
                            .padding(.horizontal, 10)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    if isGenresEnabled {
                        ForEach(genreList, id: \.self) { item in
                            FilterGenreButton(genre: item)
                        }
                    }
                    
                    if isCountriesEnabled {
                        ForEach(countryList, id: \.self) { item in
                            FilterCountryButton(country: item)
                        }
                    }
                    
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environmentObject(StationListModelView())
    }
}
