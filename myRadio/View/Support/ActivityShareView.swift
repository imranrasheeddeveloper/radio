//
//  ActivityShareView.swift
//  myRadio
//
//  Created by mt on 26.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
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
