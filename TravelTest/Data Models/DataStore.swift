//
//  DataStore.swift
//  TravelTest
//
//  Created by Itamar Biton on 17/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

class DataStore {
    static let shared = DataStore()
    
    lazy var stations: [TrainStation] = {
        return self.indexedStations.map { $0.1 }.sorted { $0.name < $1.name }
    }()
    
    private var indexedStations = [String: TrainStation]()
    private var recentRoutes = [RecentRoute]()
    private var favouriteRoutes = [String : FavouriteRoute]()
    
    init() {
        if let savedRecentRoutesData = UserDefaults.standard.data(forKey: UserDefaultsKeys.recentRoutes) {
            let decoder = JSONDecoder()
            do {
                self.recentRoutes = try decoder.decode([RecentRoute].self, from: savedRecentRoutesData)
            } catch let error {
                print("decoding of information failed: \(error.localizedDescription)")
            }
        } else {
            do {
                let encoder = JSONEncoder()
                let newSavedRecentRoutesData = try encoder.encode(self.recentRoutes)
                UserDefaults.standard.set(newSavedRecentRoutesData, forKey: UserDefaultsKeys.recentRoutes)
            } catch let error {
                print("encoding of information failed: \(error.localizedDescription)")
            }
        }
        
        if let savedFavouriteRoutsData = UserDefaults.standard.data(forKey: UserDefaultsKeys.favouriteRoutes) {
            let decoder = JSONDecoder()
            do {
                self.favouriteRoutes = try decoder.decode([String : FavouriteRoute].self, from: savedFavouriteRoutsData)
            } catch let error {
                print("decoding of information failed: \(error.localizedDescription)")
            }
        } else {
            do {
                let encoder = JSONEncoder()
                let newSavedFavouriteRoutsData = try encoder.encode(self.favouriteRoutes)
                UserDefaults.standard.set(newSavedFavouriteRoutsData, forKey: UserDefaultsKeys.favouriteRoutes)
            } catch let error {
                print("decoding of information failed: \(error.localizedDescription)")
            }
        }
    }
    
    func set(stations: [TrainStation]) {
        var indexedStations = [String: TrainStation]()
        for station in stations {
            indexedStations[station.id] = station
        }
        
        self.indexedStations = indexedStations
    }
    
    func station(forId id: String) -> TrainStation? {
        return indexedStations[id]
    }
    
    func getRecentRoutes() -> [RecentRoute] {
        return self.recentRoutes
    }
    
    func getFavouriteRoutes() -> [FavouriteRoute] {
        return self.favouriteRoutes.map { $0.1 }
    }
    
    func add(recentRoute: RecentRoute) {
        self.recentRoutes.append(recentRoute)
        self.recentRoutes = self.recentRoutes.suffix(10)
        
        let decoder = JSONDecoder()
        if let savedRecentRoutesData = UserDefaults.standard.data(forKey: UserDefaultsKeys.recentRoutes) {
            do {
                var savedRecentRoutes = try decoder.decode([RecentRoute].self, from: savedRecentRoutesData)
                savedRecentRoutes.append(recentRoute)
                savedRecentRoutes = savedRecentRoutes.suffix(5)
                
                let encoder = JSONEncoder()
                let newSavedRecentRoutesData = try encoder.encode(savedRecentRoutes)
                UserDefaults.standard.set(newSavedRecentRoutesData, forKey: UserDefaultsKeys.recentRoutes)
            } catch let error {
                print("encoding/decoding failed, \(error.localizedDescription)")
            }
        }
    }
    
    func add(favouriteRoute: FavouriteRoute) {
        self.favouriteRoutes[favouriteRoute.id] = favouriteRoute
        
        let decoder = JSONDecoder()
        if let savedFavouriteRoutesData = UserDefaults.standard.data(forKey: UserDefaultsKeys.favouriteRoutes) {
            do {
                var savedFavouriteRoutes = try decoder.decode([String : FavouriteRoute].self, from: savedFavouriteRoutesData)
                savedFavouriteRoutes[favouriteRoute.id] = favouriteRoute
                
                let encoder = JSONEncoder()
                let newSavedFavouriteRoutesData = try encoder.encode(savedFavouriteRoutes)
                UserDefaults.standard.set(newSavedFavouriteRoutesData, forKey: UserDefaultsKeys.favouriteRoutes)
            } catch let error {
                print("encoding/decoding failed: \(error.localizedDescription)")
            }
        }
        
    }

    struct UserDefaultsKeys {
        static let recentRoutes = "recent_routes"
        static let favouriteRoutes = "favourite_routes"
    }
}
