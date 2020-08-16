//
//  ShareButton.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct ShareButton: View {
    // MARK: - PROPERTIES
    let station: Station
    let size: CGFloat
    
    @State private var showShareSheet: Bool = false
    
    // MARK: - VIEW
    var body: some View {
        Button( action: {
            self.showShareSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width:size, height: size)
                .foregroundColor(Color(COLOR_Action_Buttons))
                .padding(10)
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityShareView(items: [shareMessage, self.station.title, URL(string: shareURL)!])
        }
    }
}

// MARK: - PREVIEW
struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton(station: sampleStationList[0], size: 40)
            .previewLayout(.sizeThatFits)
        
    }
}
