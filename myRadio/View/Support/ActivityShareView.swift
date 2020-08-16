//
//  ActivityShareView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI
import Foundation

final class ActivityShareView: UIViewControllerRepresentable  {
    
    var items: [Any]
    
    init(items: [Any]) {
        self.items = items
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return UIActivityViewController(activityItems:items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
