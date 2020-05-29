//
//  PreviousButton.swift
//  myRadio
//
//  Created by muhammed on 28.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct PreviousButton: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel
        
    // MARK: - VIEW
    var body: some View {
        
        Button(action: {
            self.playerViewModel.streamPreviousStation()
        }) {
            Image(systemName: "backward.end.fill")
                .foregroundColor(.gray)
                .padding(20)
                .modifier(PlayerControllerButtonModifier())
        }
    }
}

struct PreviousButton_Previews: PreviewProvider {
    static var previews: some View {
        PreviousButton()
    }
}
