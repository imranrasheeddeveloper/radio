//
//  RecordingNameView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct RecordingNameView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var fileName: String = ""
    
    // MARK: - VIEW
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            TextField("Enter Record Name Here", text: self.$fileName)
                .padding()
            
            Button(action: {
                self.playerViewModel.updateLastRecordName(name: self.fileName)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Record")
                    .foregroundColor(Color.white)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .padding()
                    .background(
                        Capsule()
                            .foregroundColor(Color(UIColor.systemBlue))
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
        } // VStack
    } // body
}

struct RecordingNameView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingNameView()
    }
}
