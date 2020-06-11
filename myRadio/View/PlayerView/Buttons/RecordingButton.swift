//
//  RecordingButton.swift
//  myRadio
//
//  Created by muhammed on 10.06.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct RecordingButton: View {
    // MARK: - PROPERTIES
    let size: CGFloat
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var showRecordingsModal: Bool = false
    
    // MARK: - VIEW
    var body: some View {
        Button(action: {
            self.showRecordingsModal.toggle()
        }) {
            Image(systemName: "recordingtape")
                .resizable()
                .scaledToFit()
                .frame(width:size, height: size)
                .foregroundColor(Color(COLOR_Action_Buttons))
                .padding(10)            
        }.sheet(isPresented: $showRecordingsModal) {
            RecordingsView()
                .environmentObject(self.playerViewModel)
        }
    }
}

struct RecordingButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordingButton(size: 40)
    }
}
