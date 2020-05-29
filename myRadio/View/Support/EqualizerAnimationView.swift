//
//  EqualizerAnimationView.swift
//  myRadio
//
//  Created by muhammed on 28.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct EqualizerAnimationView: View {
    // MARK: - PROPERTIES
    @State var animate: Bool = false
    
    private let width: CGFloat = 1
    
    // MARK: - VIEW
    var body: some View {
        HStack {
            
            Capsule().frame(width: width, height: animate ? 11 : 6)
            .animation(
                Animation
                    .easeIn(duration: 0.3)
                    .repeatForever()
            )
            Capsule().frame(width: width, height: animate ? 3 : 8)
            .animation(
                Animation
                    .easeIn(duration: 0.35)
                    .repeatForever()
            )
            Capsule().frame(width: width, height: animate ? 13 : 8)
            .animation(
                Animation
                    .easeIn(duration: 0.5)
                    .repeatForever()
            )
            Capsule().frame(width: width, height: animate ? 6 : 15)
            .animation(
                Animation
                    .easeIn(duration: 0.4)
                    .repeatForever()
            )
            Capsule().frame(width: width, height: animate ? 11 : 7)
            .animation(
                Animation
                    .easeIn(duration: 0.45)
                    .repeatForever()
            )
        } // HStack
            .onAppear() {
                self.animate.toggle()
        }
    
    }
}

// MARK: - PREVIEW
struct EqualizerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerAnimationView()
    }
}
