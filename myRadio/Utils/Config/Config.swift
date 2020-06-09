//
//  Config.swift
//  myRadio
//
//  Created by mt on 25.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ADMOB
// TODO: Replace by your admob banner ID
// TODO: You should also replace ID in Info.plist file, for more detail plase read user manual
//---GOOGLE ADMOB AND IN-APP PURCHASE IDS HERE---//
let adMobBannerID = "ca-app-pub-3940256099942544/2934735716"
let showAds = false // Set it false if you don't want to show ads

// MARK: - DATA SOURCE
// Remote CSV File
let csvUrl = "https://docs.google.com/spreadsheets/d/e/2PACX-1vR7B_jzm-N-PVek6OfWGzSNcWml_-QIor5aM72j-vhSITo4VyYQCO_Kae0iG3SN8Ll7MPHPul_Uwszk/pub?output=csv"

// MARK: - OPTIONS
let showLogoInPlayerScreen = true /// (Note: You should set "logo_player" in the Assets.xcassets if you set true)

// MARK: - LOCALIZATIONS
// Sharing confiigurations
let shareMessage: String = "I am listening this station on the myRadio: "
let shareURL: String = "https://apps.apple.com/app/id1515483035"


// Texts
let favoritesText = "Favorites"
let genresText = "Genres"
let resetFilterText = "Reset Filter"


// MARK: - COLORS
// Colors
// Bottom Controller Gradient Coloe
let COLOR_PlayControllerGradient1 = UIColor.systemBlue
let COLOR_PlayControllerGradient2 = UIColor.systemRed

// Favorite And Share Action Buttons Color
let COLOR_Action_Buttons = UIColor.systemGray
let COLOR_Favorite_Button_Active = UIColor.systemPink

// Genres Color
let COLOR_Genre_Background = UIColor.systemBlue
