//
//  AppDelegate.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleMobileAds
import Reachability
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var reachability: Reachability!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        S3AppRater.usesUntilPrompt = usesUntilPrompt
        S3AppRater.launch()
        do {
               try reachability = Reachability()
               NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
               try reachability.startNotifier()
               } catch {
                    print("This is not working.")
               }
            return true
    }
     @objc func reachabilityChanged(_ note: NSNotification) {
    let reachability = note.object as! Reachability
    if reachability.connection != .unavailable {
    if reachability.connection == .wifi {
    print("Reachable via WiFi")
    } else {
    print("Reachable via Cellular")
        
    }
    } else {
    print("Not reachable")
    }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

