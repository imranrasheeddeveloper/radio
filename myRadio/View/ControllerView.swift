//
//  ControllerView.swift
//  myRadio
//
//  Created by mt on 24.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct ControllerView: View {
    // MARK: - PROPERTIES
    @State private var showModal: Bool = false
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    // MARK: - VIEW
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            Button(action: {
                self.showModal.toggle()
            }) {
                Image(systemName: "chevron.up.circle.fill")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .shadow(radius: 4)
            }.sheet(isPresented: $showModal) {
                PlayerView(station: self.playerViewModel.station)
                    .environmentObject(self.playerViewModel)
                    .environmentObject(self.stationListViewModel)
                
            }
                
            .padding(10)
            
            Spacer()
            
            Text(playerViewModel.station.title)
            
            Spacer()
           
            if(playerViewModel.isLoading) {
                ActivityIndicator()
                    .frame(width:40, height: 40)
                    .foregroundColor(.orange)
                    .padding(10)
            } else {
                Button(action: {
                    self.playerViewModel.pauseResume()
                }) {
                    Image(systemName:playerViewModel.isPlaying ? "pause.circle" : "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width:40, height: 40)
                        .foregroundColor(Color.white)
                        .shadow(radius: 4)
                }
                .padding(10)
            }
            
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(COLOR_PlayControllerGradient1), Color(COLOR_PlayControllerGradient2)]), startPoint: .leading, endPoint: .trailing))
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
            .environmentObject(PlayerViewModel())
            .previewLayout(.sizeThatFits)

    }
}
