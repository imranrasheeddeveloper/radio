//
//  Station.swift
//  myRadio
//
//  Created by mt on 23.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import Foundation

struct Station: Identifiable, Codable, Equatable {
    var id: String
    var countryCode: String
    var title: String
    var logo: String
    var streamURL: String
    var desc: String
    var genres: [String]
    var status: Bool
}
