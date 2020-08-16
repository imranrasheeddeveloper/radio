//
//  SleepButton.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI

struct SleepButton: View {
    // MARK: - PROPERTIES
    let size: CGFloat
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var showSleepModal: Bool = false
    
    // MARK: - VIEW
    var body: some View {
        Button(action: {
            if(self.playerViewModel.isSleepMode) {
                self.playerViewModel.disableSleepMode()
            } else {
                self.showSleepModal.toggle()
            }
        }) {
            Image(systemName: "moon.zzz.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(self.playerViewModel.isSleepMode ? Color(UIColor.systemGreen) :  Color(COLOR_Action_Buttons))
                .padding(10)
        }.sheet(isPresented: $showSleepModal) {
            SleepView()
                .environmentObject(self.playerViewModel)
        }
    }
}

struct SleepButton_Previews: PreviewProvider {
    static var previews: some View {
        SleepButton(size: 40)
    }
}
