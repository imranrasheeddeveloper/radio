//
//  InternetReachability.swift
//  GhanaRadio
//
//  Created by Muhammad Imran on 22/08/2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI
import Reachability
struct InternetReachability: View {
     @State private var animationAmount: CGFloat = 1
    var reachability: Reachability!
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color(red: 200/255, green: 143/255, blue: 32/255))
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                Image("internet")
                    .resizable()
                     .frame(width: 300, height: 300)
                     .padding(20)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                .scaleEffect(animationAmount)
                .animation(.easeInOut(duration: 2))
                Spacer()
                Text("No Internet Plaes Check Your Conectvitiy")
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                
                
                
                }) { () in
                    Text("Try Again")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.all, 10)
                        .padding([.leading,.trailing], 30)
                        .cornerRadius(20)
                        .background(Color.pink)
                    
                }
                Spacer()
            }
            
            
        }
    }

}

struct InternetReachability_Previews: PreviewProvider {
    static var previews: some View {
        InternetReachability()
    }
}

