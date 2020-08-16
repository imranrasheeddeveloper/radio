//
//  Station.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import Foundation

struct Station: Identifiable, Codable, Equatable, Hashable {
    var id: String
    var countryCode: String
    var title: String
    var logo: String
    var streamURL: String
    var desc: String
    var genres: [String]
    var status: Bool
}
