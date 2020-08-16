//
//  GenresView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct GenresView: View {
    // MARK: - PROPERTIES
    var genres: [String]

    // MARK: - VIEW
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 5) {
                ForEach(self.genres, id: \.self) { item in
                    Text(item)
                        .font(.system(.footnote, design: .rounded))
                        .fontWeight(.light)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 1)
                        .background(
                            Capsule()
                                .foregroundColor(Color(COLOR_Genre_Background))
                                .opacity(0.3)
                        )
                }
            } // HStack
        } // ScrollView  
    }
}

struct GenresView_Previews: PreviewProvider {
    static var previews: some View {
        GenresView(genres: sampleStationList[0].genres)
            .previewLayout(.sizeThatFits)
    }
}
