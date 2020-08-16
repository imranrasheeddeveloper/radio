//
//  SleepView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct SleepView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.presentationMode) var presentationMode
    private let minutes: [Int] = [1, 5, 10, 15, 20, 25, 30, 40, 45, 50, 60, 75, 90, 120, 150, 180]
    
    private let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - VIEW
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            Text("Sleep Timer")
                .modifier(TitleModifier())
            
            Text("Please select the time you want the radio to stop")
                .multilineTextAlignment(.center)
                .padding()
            
            List(minutes, id: \.self) { item in
                
                Button(action: {
                    self.hapticImpact.impactOccurred()
                    self.playerViewModel.setTimer(countDown: item)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("\(item) min")
                }
                
                
            }
        }
        
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
