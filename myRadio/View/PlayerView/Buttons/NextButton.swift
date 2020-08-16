//
//  NextButton.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct NextButton: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel
        
    // MARK: - VIEW
    var body: some View {
        
        Button(action: {
            self.playerViewModel.streamNextStation()
        }) {
            Image(systemName: "forward.end.fill")
                .foregroundColor(.gray)
                .padding(20)
                .modifier(PlayerControllerButtonModifier())
        }
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        NextButton()
    }
}
