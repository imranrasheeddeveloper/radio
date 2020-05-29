//
//  EqualizerStartingAnimationView.swift
//  myRadio
//
//  Created by muhammed on 28.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct EqualizerStartingAnimationView: View {
    // MARK: - PROPERTIES
    @State var animate: Bool = false
    
    private let width: CGFloat = 1
    
    // MARK: - VIEW
    var body: some View {
        HStack {
        
            Capsule()
                .frame(width: width, height: animate ? 1 : 10)
                .animation(
                    Animation
                        .easeIn(duration: 0.5)
                        .repeatForever()
                )
            Capsule()
                    .frame(width: width, height: animate ? 1 : 10)
                    .animation(
                        Animation
                            .easeIn(duration: 0.5)
                            .repeatForever()
                            .delay(0.1)
                )
            Capsule()
                    .frame(width: width, height: animate ? 1 : 10)
                    .animation(
                        Animation
                            .easeIn(duration: 0.5)
                            .repeatForever()
                            .delay(0.2)
                )
            
            Capsule()
                    .frame(width: width, height: animate ? 1 : 10)
                    .animation(
                        Animation
                            .easeIn(duration: 0.5)
                            .repeatForever()
                            .delay(0.3)
                )
            
            Capsule()
                    .frame(width: width, height: animate ? 1 : 10)
                    .animation(
                        Animation
                            .easeIn(duration: 0.5)
                            .repeatForever()
                            .delay(0.4)
                )
        } // HStack
        .onAppear() {
            self.animate.toggle()
        }
    }
}

struct EqualizerStartingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerStartingAnimationView()
    }
}
