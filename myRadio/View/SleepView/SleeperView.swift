//
//  SleeperView.swift
//  GhanaRadio
//
//  Created by Muhammad Imran on 18/08/2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct SleeperView: View {
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = 0
    @EnvironmentObject var playerViewModel: PlayerViewModel
       @Environment(\.presentationMode) var presentationMode
       private let minutes: [String] = ["1", "5", "10", "15", "20", "25", "30", "40", "45", "50", "60", "75", "90", "120", "150", "180"]
    private let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
        
    var body: some View {
       VStack {
        Picker(selection: $selectedColor, label: Text("")) {
             ForEach(0 ..< minutes.count) {
                Text(self.minutes[$0])
                
             }
          }
        .labelsHidden()
        .clipped()
//          Text("You selected: \(minutes[selectedColor]) Minutes")
         
       
       }
    }
    
  public  func svae() {
        self.hapticImpact.impactOccurred()
        //self.playerViewModel.setTimer(countDown: Int(minutes[$0]) ?? 0)
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct SleeperView_Previews: PreviewProvider {
    static var previews: some View {
        SleeperView()
    }

}
