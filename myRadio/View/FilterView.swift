//
//  FilterView.swift
//  myRadio
//
//  Created by mt on 26.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    
    // MARK: - VIEW
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .center, spacing: 10) {
                Text(genresText)
                    .modifier(TitleModifier())

                Spacer()
                
                if self.stationListViewModel.showResetSelectedGenresButton {
                    Button(action: {
                        self.stationListViewModel.resetSelectedGenres()
                    }) {
                        Text(resetFilterText)
                            .font(.system(.footnote, design: .rounded))
                            .padding(.horizontal, 10)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(genreList, id: \.self) { item in
                        FilterGenreButton(genre: item)
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
