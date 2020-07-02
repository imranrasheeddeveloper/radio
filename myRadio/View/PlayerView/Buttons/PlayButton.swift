//
//  PlayButton.swift
//  myRadio
//
//  Created by muhammed on 28.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct PlayButton: View {

    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var interstitial:Interstitial = Interstitial()

    // MARK: - VIEW
    var body: some View {
        
        Button(action: {
            self.playerViewModel.togglePlaying()
            
            if( self.playerViewModel.isPlaying == false) {
                if(showInsterstitialAds) {
                    self.interstitial.showAd()
                }
            }
            
        }) {
            Image(systemName: playerViewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width:30, height:30)
                .foregroundColor(.gray)
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
