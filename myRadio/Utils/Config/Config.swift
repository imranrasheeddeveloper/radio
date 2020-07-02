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
let adMobInsterstitialID = "ca-app-pub-3940256099942544/4411468910"
// Set it false if you don't want to show ads
let showBannerAds = true
let showInsterstitialAds = true

// MARK: - DATABASE
// DATA Source
enum DatabaseSource {
    case FIREBASE_FIRESTORE
    case REMOTE_CSV
    case REMOTE_JSON
    case LOCAL_JSON
}

///
// Please comment/uncomment which data source that you will use
///
let databaseSource: DatabaseSource = DatabaseSource.FIREBASE_FIRESTORE
//let databaseSource: DatabaseSource = DatabaseSource.REMOTE_CSV
//let databaseSource: DatabaseSource = DatabaseSource.LOCAL_JSON
//let databaseSource: DatabaseSource = DatabaseSource.REMOTE_JSON

// Remote CSV File
let csvUrl = "https://docs.google.com/spreadsheets/d/e/2PACX-1vR7B_jzm-N-PVek6OfWGzSNcWml_-QIor5aM72j-vhSITo4VyYQCO_Kae0iG3SN8Ll7MPHPul_Uwszk/pub?output=csv"

// Remote json file
let jsonUrl = "https://s3soft.com/codecanyon/assets/files/station_list.json"

// Local json file name
let dataJsonFile = "station_list.json" /// File is located in Resources folder


// MARK: - OPTIONS

// (Note: You should set "logo_player" in the Assets.xcassets if you set true)
let showLogoInPlayerScreen = false

// Open full player screen when tap to station in main list
let openFullPlayerViewAuto = false

// Artwork Image Size
let artworkSize:CGFloat = 180


// MARK: App review
let appID = "1515483035" /// You can find the app id in the appstoreconnect

// MARK: - LOCALIZATIONS
// Sharing confiigurations
let shareMessage: String = "I am listening this station on the myRadio: "
let shareURL: String = "https://apps.apple.com/app/id1515483035"

// Texts
let favoritesText = "Favorites"
let genresText = "Genres"
let countriesText = "Countries"
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
