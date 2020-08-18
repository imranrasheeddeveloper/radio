//
//  Modifiers.swift
//  myRadio
//
//  Created by mt on 26.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import SwiftUI

struct TitleModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.leading, 15)
            .padding(.top, 5)
    }
}

struct LogoModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .shadow(radius: 5)
            .overlay(
                Circle()
                    .stroke(Color(UIColor.orange), lineWidth: 1)
                    .opacity(0.3)
            )
            .padding(10)
    }
}

struct TrackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Rectangle())
            .shadow(radius: 5)
            .overlay(
                Circle()
                    .stroke(Color(UIColor.systemBlue), lineWidth: 1)
                    .opacity(0.3)
            )
            .padding(10)
    }
}


struct PlayerControllerButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Circle()
                    .fill(Color("ColorOffWhiteAdaptive"))
                    .shadow(color: Color("ColorOffWhiteShadowFinishAdaptive"), radius: 10, x: 10, y: 10)
//                    .shadow(color: Color("ColorOffWhiteShadowStartAdaptive"), radius: 10, x: -5, y: -5)
            )
    }
}

