//
//  MicrophoneAnimationView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct MicrophoneAnimationView: View {
    @State private var animateRedColor = false
    @State private var animateBlueColor = false
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width:100, height:100)
                .foregroundColor(Color.red)
                .scaleEffect(animateRedColor ? 1 : 0.8)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).speed(2))
                .onAppear() {
                    self.animateRedColor.toggle()
                }
            
            Circle()
                .frame(width:50, height:50)
                .foregroundColor(Color.blue)
                .scaleEffect(animateBlueColor ? 1 : 1.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).speed(3))
                .onAppear() {
                    self.animateBlueColor.toggle()
                }
            
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.yellow)
            
            Image(systemName: "mic")
        }
    }
}

struct MicrophoneAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneAnimationView()
    }
}
