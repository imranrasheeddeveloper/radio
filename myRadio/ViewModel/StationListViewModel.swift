//
//  StationListViewModel.swift
//  myRadio
//
//  Created by mt on 23.05.2020.
//  Copyright © 2020 S3soft. All rights reserved.
//

import Foundation
import SwiftCSV

// All station list will be loaded at the opening of application
var stationList:[Station] = []
var originalStationList:[Station] = []
var genreList:[String] = []

// Used for the SWIFTUI Previews
let sampleStationList = [
    Station(
        id: "sampleID",
        countryCode: "uk",
        title: "Sample FM 1",
        logo: "https://s3soft.com/wp-content/uploads/2020/03/logo-1.png",
        streamURL: "http://strm112.1.fm/acountry_mobile_mp3",
        desc: "Sample Description Here 1",
        genres: ["Sport", "Football", "Jazz", "Soul", "Pop"],
        status: true
    )
]

final class StationListModelView: ObservableObject {
    
    @Published var dataIsLoading: Bool = false
    @Published var favoriteStationList: [Station] = []
    @Published var selectedGenres: [String] = []
    @Published var showResetSelectedGenresButton: Bool = false
    
    // Standar user defaults
    private let defaults = UserDefaults.standard
    
    // Keep only id's of radio stations in the user defaults
    private var favoriteStationIDList: [String] = []
    
    init() {
        // Load favorite id list from the user defaults
        loadFavoriteIdList()
        
        // Load station from the remote content
        loadStations()
    }
    
    func loadFavoriteIdList() {
        let data = UserDefaults.standard.data(forKey: keyFavorites)
        if (data != nil) {
            favoriteStationIDList = try! JSONDecoder().decode([String].self, from: data!)
        } else {
            favoriteStationIDList = []
        }
    }
    
    func loadStations() {
        self.dataIsLoading = true
        stationList = []
        genreList = []
        do {
            let csvFile: CSV = try CSV(url: URL(string: csvUrl)!)
            
            try csvFile.enumerateAsDict { dict in
                
                
                
                // If station row is active, add to list
                if dict["STATUS"] == "1" {
                    
                    // Parse genres from the csv response
                    var genres:[String] = []
                    for genre in dict["GENRES"]!.components(separatedBy: ",") {
                        genres.append(genre)
                        
                        // Add genre to the genres list if not added
                        if genreList.firstIndex(of: genre) == nil {
                            genreList.append(genre)
                        }
                    }
                    
                    
                    // Create a station object
                    let station: Station = Station(
                        id: dict["ID"]!,
                        countryCode: dict["COUNTRY"]!,
                        title: dict["TITLE"]!,
                        logo: dict["LOGO"]!,
                        streamURL: dict["STREAMURL"]!,
                        desc: dict["DESC"]!,
                        genres: genres,
                        status: true
                    )

                    // Add station to the all station list
                    stationList.append(station)
                    
                    // Check the station id is in favorite list
                    // If yes, add the station to favorite station list
                    if self.isFavorite(stationID: station.id) {
                        self.favoriteStationList.append(station)
                    }
                }
                
            }
            
            self.dataIsLoading = false
            
            originalStationList = stationList
        }
        catch {
            self.dataIsLoading = false
            print("ERROR: Loading CSV File error")
        }
    }
    
    // MARK: - GENRES
    func resetSelectedGenres() {
        selectedGenres = []
        setShowResetSelectedGenresButton()
        setStationList()
    }
    
    func toggleGenre(genre: String) {
        // Check the genre is selected
        // if yes, unselect it; if no, select it
        if let index = selectedGenres.firstIndex(of: genre) {
            selectedGenres.remove(at: index)
        } else {
            selectedGenres.append(genre)
        }
        
        setStationList()
        
        setShowResetSelectedGenresButton()
    }
    
    private func setStationList() {
        // if no selected genres, show all stations
        if selectedGenres.count == 0 {
            stationList = originalStationList
        } else {
            stationList = []
            
            for genre in selectedGenres {
                for station in originalStationList {
                    if station.genres.contains(genre) {
                        if !stationList.contains(station) {
                            stationList.append(station)
                        }
                    }
                }
            }
        }
    }
    
    private func setShowResetSelectedGenresButton() {
        if selectedGenres.count == 0 {
            showResetSelectedGenresButton = false
        } else {
            showResetSelectedGenresButton = true
        }
    }
    
    func isGenreSelected(name: String) -> Bool {
        if selectedGenres.firstIndex(of: name) != nil {
            return true
        }
        return false
    }
    
    // MARK: - FAVORITES
    func toggleFavorite(station: Station) {
       // If index found, then remove it from favorites
        if let index = favoriteStationIDList.firstIndex(of: station.id) {
            favoriteStationIDList.remove(at: index)
            if let index = favoriteStationList.firstIndex(of: station) {
                favoriteStationList.remove(at: index)
            }
       } else {
           // If index not found, add to favorites
            favoriteStationIDList.append(station.id)
            favoriteStationList.append(station)
       }
       let data = try! JSONEncoder().encode(favoriteStationIDList)
       defaults.set(data, forKey: keyFavorites)
    }

    func isFavorite(stationID: String) -> Bool {
       if favoriteStationIDList.firstIndex(of: stationID) != nil {
           return true
       }
       return false
    }
}




