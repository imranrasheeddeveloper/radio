//
//  MicrophoneView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct MicrophoneView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width:100, height:100)
                .foregroundColor(Color.red)
            
            Circle()
                .frame(width:60, height:60)
                .foregroundColor(Color.blue)
            
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.yellow)
            
            Image(systemName: "mic")
        }
    }
}

struct MicrophoneView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneView()
    }
}
