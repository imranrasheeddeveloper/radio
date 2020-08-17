//
//  PlayButton.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct PlayButton: View {

    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel

   

    // MARK: - VIEW
    var body: some View {
        
        Button(action: {
            self.playerViewModel.togglePlaying()
            
            if( self.playerViewModel.isPlaying == false) {
               
            }
            
        }) {
            Image(systemName: playerViewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width:30, height:30)
                .foregroundColor(.orange)
                .padding(30)
                .modifier(PlayerControllerButtonModifier())
        }
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayButton()
                .background(Color(UIColor.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewLayout(.fixed(width: 200, height: 200))
            .environmentObject(PlayerViewModel())
            


            PlayButton()
                .background(Color(UIColor.systemBackground))
                .environment(\.colorScheme, .light)
                .previewLayout(.fixed(width: 200, height: 200))
            .environmentObject(PlayerViewModel())
        }


    }
}
