//
//  Track.swift
//  myRadio
//
//  Created by muhammed on 10.06.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import Foundation
import UIKit

struct Track {
    var title: String
    var artist: String
    var artworkURL: String?
    var artworkImage: UIImage?
    
    init(title: String, artist: String) {
        self.title = title
        self.artist = artist
    }
    
    func metaTitle() -> String {
        if self.artist.count > 0 {
            return "\(self.artist) - \(self.title)"
        }
        
        return title
    }
}
