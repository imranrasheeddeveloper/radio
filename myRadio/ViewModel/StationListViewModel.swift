//
//  StationListViewModel.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import Foundation
import SwiftCSV
import FirebaseFirestore
import CodableFirebase
import SystemConfiguration
let db = Firestore.firestore()

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
    
    
    // MARK: - SETUP
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
        
        switch databaseSource {
            case DatabaseSource.FIREBASE_FIRESTORE:
                readDataFromFireStore()
                break;
            case DatabaseSource.REMOTE_CSV:
                readDataFromRemoteCSV()
                break;
            case DatabaseSource.REMOTE_JSON:
                readFromRemoteJson()
                break;
            case DatabaseSource.LOCAL_JSON:
                readFromLocal()
                break;
        }
    }
    
    /// Configure genres, countries, favorites
    func configureLoadedData() {
        // Keep the original data for filtering
        originalStationList = stationList
        
        for station in stationList {
            // Check genres
            station.genres.forEach{
                // Add genre to the genres list if not added
                if genreList.firstIndex(of: $0) == nil {
                    genreList.append($0)
                }
            }
            
            // Add country to the countries list if not added
            if countryList.firstIndex(of: station.countryCode) == nil {
                countryList.append(station.countryCode)
            }
            
            // Check the station id is in favorite list
            // If yes, add the station to favorite station list
            if self.isFavorite(stationID: station.id) {
                self.favoriteStationList.append(station)
            }
        }
    }
    
    
    // MARK: FIREBASE FIRESTORE
    
    func readDataFromFireStore() {
        db.collection(FIRStoreStationsCollection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let station = try! FirestoreDecoder().decode(Station.self, from: document.data())
                    
                    // Add station if status is true
                    if station.status {
                        stationList.append(station)
                    }
                }
                // Configure genres, countries, favorites
                self.configureLoadedData()
            }

            self.dataIsLoading = false
        }
    }
    
    // MARK: REMOTE CSV GOOGLE SHEET
    
    func readDataFromRemoteCSV() {
        let reach = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reach!, &flags)
        if self.isNetwork(with: flags){
                    do {
                 let csvFile: CSV = try CSV(url: URL(string: csvUrl)!)
                 
                 try csvFile.enumerateAsDict { dict in
                     
                     // If station row is active, add to list
                     if dict["STATUS"] == "1" {
                         
                         // Parse genres from the csv response
                         var genres:[String] = []
                         for genre in dict["GENRES"]!.components(separatedBy: ",") {
                             genres.append(genre)
                         }
                         
                         let countryCode = dict["COUNTRY"]!
                         
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
                     }
                 }

                 // Configure genres, countries, favorites
                 configureLoadedData()
                 self.dataIsLoading = false
             }
             catch {
                 print("ERROR: Loading CSV File error")
             }

        }
        else{
          
    
        }

    }
    
    func isNetwork(with flag :SCNetworkReachabilityFlags) -> Bool {
          let isreachable = flag.contains(.reachable)
          let neededconection = flag.contains(.connectionRequired)
          let connectionauto = flag.contains(.connectionOnDemand) || flag.contains(.connectionOnTraffic)
          
          let connectWitoutInteraction = connectionauto && !flag.contains(.interventionRequired)
          return isreachable && (!neededconection || connectWitoutInteraction)
      }
    
    // MARK: REMOTE JSON
    func readFromRemoteJson() {
        let reach = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reach!, &flags)
        if self.isNetwork(with: flags){
            if let url = URL(string: jsonUrl) {
                      let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                          if let error = error {
                              fatalError("Couldn't fetch remote json file. Error: \(error)")
                          } else if let data = data {
                              do {
                                  let decoder = JSONDecoder()
                                  stationList = try decoder.decode([Station].self, from: data)
                                  // Configure genres, countries, favorites
                                  self.configureLoadedData()
                                  DispatchQueue.main.async {
                                      self.dataIsLoading = false
                                  }
                              } catch {
                                  fatalError("Couldn't parse remote json file")
                              }
                          } else {
                              fatalError("Couldn't fetch data")
                          }
                      }
                      
                      urlSession.resume()
                  }
        }
      
   }
    
    // MARK: LOCAL DATA
    func readFromLocal() {
        stationList = loadLocalJson(dataJsonFile)
    
        // Configure genres, countries, favorites
        configureLoadedData()
        self.dataIsLoading = false
    }
    
    func loadLocalJson<T: Decodable>(_ filename: String) ->T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else { fatalError("Couldn't find \(filename) in main bundle")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch  {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    // MARK: - FILTER
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




