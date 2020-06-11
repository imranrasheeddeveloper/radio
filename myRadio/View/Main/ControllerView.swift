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
                
                if (self.playerViewModel.track.artworkURL != nil) {
                    ImageLoaderView(imageUrl: self.playerViewModel.track.artworkURL!)
                        .frame(width: 40, height: 40, alignment: .center)
                    .modifier(TrackModifier())
                } else {
                    ImageLoaderView(imageUrl: self.playerViewModel.station.logo)
                        .frame(width: 40, height: 40, alignment: .center)
                        .modifier(LogoModifier())
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 5) {
                    Image(systemName: "chevron.up")
                        .resizable()
                        .frame(width: 15, height: 5, alignment: .center)
                        .foregroundColor(Color.white)
                        .shadow(radius: 4)
                    
                    Text(playerViewModel.station.title)
                        .font(.system(.body, design: .rounded))
                    
                    Text(self.playerViewModel.track.metaTitle())
                        .font(.system(size:10, design: .rounded))
                        .fontWeight(.light)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showModal) {
                PlayerView(station: self.playerViewModel.station)
                    .environmentObject(self.playerViewModel)
                    .environmentObject(self.stationListViewModel)
                
            }
            
            
            
            Spacer()
           
            if(playerViewModel.isLoading) {
                ActivityIndicator()
                    .frame(width:40, height: 40)
                    .foregroundColor(.orange)
                    .padding(10)
            } else {
                Button(action: {
                    self.playerViewModel.togglePlaying()
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
