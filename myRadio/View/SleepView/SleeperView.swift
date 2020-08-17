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

    var body: some View {
       VStack {
          Picker(selection: $selectedColor, label: Text("Please choose a color")) {
             ForEach(0 ..< colors.count) {
                Text(self.colors[$0])
             }
          }
          Text("You selected: \(colors[selectedColor])")
       }
    }
}


struct SleeperView_Previews: PreviewProvider {
    static var previews: some View {
        SleeperView()
    }
}
