//
//  S3AppRater.swift
//  myRadio
//
//  Created by muhammed on 2.07.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import Foundation
import StoreKit

struct S3AppRater {
    
    static var usesUntilPrompt = 5
    
    enum defaults : String {
        case numberOfTimesLaunched = "S3_numberOfTimesLaunched"
    }
    
    static func launch() {
        var requestReview: Bool = false
        
        incrementNumberOfTimesLaunched()
        
        let numberOfTimesLaunched: Int = UserDefaults.standard.integer(forKey: defaults.numberOfTimesLaunched.rawValue)
        
        if numberOfTimesLaunched >= usesUntilPrompt {
            UserDefaults.standard.set(0, forKey: defaults.numberOfTimesLaunched.rawValue)
            requestReview = true
        }
        
        if requestReview {
            SKStoreReviewController.requestReview()
        }
    }
    
    private static func incrementNumberOfTimesLaunched() {
        let numberOfTimesLaunched: Int = UserDefaults.standard.integer(forKey: defaults.numberOfTimesLaunched.rawValue) + 1
        UserDefaults.standard.set(numberOfTimesLaunched, forKey: defaults.numberOfTimesLaunched.rawValue)
    }
    
}
