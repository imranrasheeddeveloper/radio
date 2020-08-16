//
//  FilterGenreButton.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct FilterGenreButton: View {
    // MARK: - PROPERTIES
    var genre: String
    @EnvironmentObject var stationListViewModel: StationListModelView
    
    // MARK: - VIEW
    var body: some View {
        Button(action: {
            self.stationListViewModel.toggleGenre(genre: self.genre)
        }) {
            Text(genre)
                .font(.system(.footnote, design: .rounded))
                .fontWeight(.light)
                .padding()
                .background(
                    Capsule()
                        .foregroundColor(Color(COLOR_Genre_Background))
                        .opacity(self.stationListViewModel.isGenreSelected(name: genre) ? 0.7 : 0.3)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterGenreButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FilterGenreButton(genre: "Jazz")
                .environmentObject(StationListModelView())
                .background(Color(UIColor.systemBackground))
                .colorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            
            FilterGenreButton(genre: "Jazz")
                .environmentObject(StationListModelView())
                .background(Color(UIColor.systemBackground))
                .colorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
        
    }
}
