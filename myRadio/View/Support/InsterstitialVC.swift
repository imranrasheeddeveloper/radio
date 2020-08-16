//
//  InsterstitialVC.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleMobileAds

final class Interstitial:NSObject, GADInterstitialDelegate{
    var interstitial:GADInterstitial = GADInterstitial(adUnitID: adMobInsterstitialID)

    override init() {
        super.init()
        LoadInterstitial()
    }
     
    func LoadInterstitial(){
        let req = GADRequest()
        self.interstitial.load(req)
        self.interstitial.delegate = self
    
    }
    
    func showAd() -> Bool{
        
        if self.interstitial.isReady{
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

                self.interstitial.present(fromRootViewController: topController)
                
                return true
            }
        }
       else{
           print("Not Ready")
       }
        
        return false
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitial = GADInterstitial(adUnitID: adMobInsterstitialID)
        LoadInterstitial()
    }
}
