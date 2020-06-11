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
var countryList:[String] = []

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
    @Published var selectedCountries: [String] = []
    @Published var showResetFilterButton: Bool = false
    
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
        countryList = []
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
                    
                    let countryCode = dict["COUNTRY"]!
                    // Add genre to the genres list if not added
                    if countryList.firstIndex(of: countryCode) == nil {
                        countryList.append(countryCode)
                    }
                    
                    
                    // Create a station object
                    let station: Station = Station(
                        id: dict["ID"]!,
                        countryCode: countryCode,
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
    func resetFilter() {
        selectedGenres = []
        selectedCountries = []
        setShowResetFilterButton()
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
        
        setShowResetFilterButton()
    }
    
    func toggleCountry(country: String) {
        // Check the country is selected
        // if yes, unselect it; if no, select it
        if let index = selectedCountries.firstIndex(of: country) {
            selectedCountries.remove(at: index)
        } else {
            selectedCountries.append(country)
        }
        
        setStationList()
        
        setShowResetFilterButton()
    }
    
    
    private func setStationList() {
        // if no selected countries and genres, show all stations
        if selectedCountries.count == 0 && selectedGenres.count == 0 {
            stationList = originalStationList
            return
        }
        
        // Countries filter
        var set1Arr: [Station] = selectedCountries.count == 0 ? originalStationList : []
        for country in selectedCountries {
            for station in originalStationList {
                if station.countryCode == country {
                    if !set1Arr.contains(station) {
                        set1Arr.append(station)
                    }
                }
            }
        }
        let set1:Set<Station> = Set(set1Arr)
        
        // Genres filter
        var set2Arr: [Station] = selectedGenres.count == 0 ? originalStationList : []
        for genre in selectedGenres {
            for station in originalStationList {
                if station.genres.contains(genre) {
                    if !set2Arr.contains(station) {
                        set2Arr.append(station)
                    }
                }
            }
        }
        let set2:Set<Station> = Set(set2Arr)
        
        // Instersect filtered sets
        stationList = Array(set1.intersection(set2))
    }
    
    private func setShowResetFilterButton() {
        if selectedGenres.count == 0 && selectedCountries.count == 0 {
            showResetFilterButton = false
        } else {
            showResetFilterButton = true
        }
    }
    
    func isGenreSelected(name: String) -> Bool {
        if selectedGenres.firstIndex(of: name) != nil {
            return true
        }
        return false
    }
    
    func isCountrySelected(name: String) -> Bool {
        if selectedCountries.firstIndex(of: name) != nil {
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




