//
//  StationListView.swift
//  myRadio
//
//  Created by muhammed on 11.06.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct StationListView: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var searchText = ""
    @State private var showModal: Bool = false
    
    // MARK: - VIEW
    var body: some View {
        ScrollView {
            if self.stationListViewModel.dataIsLoading {
                 ActivityIndicator()
                 .frame(width:30, height: 30)
                 .foregroundColor(.orange)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    
                    SearchBarView(text: $searchText)
                        .padding(.vertical, 10)
                    
                    ForEach(stationList.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) })) { item in
                        Button(action: {
                            self.playerViewModel.streamStation(station: item)
                            
                            if openFullPlayerViewAuto {
                                self.showModal.toggle()
                            }
                            
                        }) {
                            StationRowView(station: item)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(self.playerViewModel.isStationPlaying(stationId: item.id) ? Color("ColorStationRowShadow") : Color.clear)
                        .sheet(isPresented: self.$showModal) {
                            PlayerView(station: self.playerViewModel.station)
                                .environmentObject(self.playerViewModel)
                                .environmentObject(self.stationListViewModel)
                        }

                        Divider()
                    } // ForEach
                } // VStack
            } // if-else
        } // ScrollView
    } // body
}

struct StationListView_Previews: PreviewProvider {
    static var previews: some View {
        StationListView()
    }
}
