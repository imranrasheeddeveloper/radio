//
//  About.swift
//  GhanaRadio
//
//  Created by Muhammad Imran on 22/08/2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct About: View {
    
    var body: some View {
        ZStack{
            Color.orange.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Swiss Radio")
                Text("Let's Play Music")
                    .font(.largeTitle)
                
                Text("Try Different Stations")
                    .foregroundColor(Color.white)
                    .background(Color.red)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .lineLimit(nil)
                    
                    .lineSpacing(10)
                    
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
    }
    
    
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
