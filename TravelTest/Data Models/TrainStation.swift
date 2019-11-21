//
//  TrainStation.swift
//  TravelTest
//
//  Created by Itamar Biton on 14/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import CoreLocation

struct TrainStationContainer: Codable {
    let stationsContainer: TrainStationsArray
    
    struct TrainStationsArray: Codable {
        let stations: [TrainStation]
        
        private enum CodingKeys: String, CodingKey {
            case stations = "Station"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case stationsContainer = "Stations"
    }
}

class TrainStation: Codable {
    let id: String
    let heName: String
    let enName: String
    let arName: String
    
    var keywords: [String]?
    
    private let _coordinate: TrainStationCoordinate
    private let _isAccessible: String
    private let _hasParking: String
    private let _paidParking: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: _coordinate.latitude, longitude: _coordinate.longitude)
    }
    
    var isAccessible: Bool {
        return _isAccessible == "2"
    }
    
    var hasParking: Bool {
        return _hasParking == "2"
    }
    
    var paidParking: Bool {
        return _paidParking == "2"
    }
    
    struct TrainStationCoordinate: Codable {
        let latitude: CLLocationDegrees
        let longitude: CLLocationDegrees
        
        private enum CodingKeys: String, CodingKey {
            case latitude = "Latitude"
            case longitude = "Longitude"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "StationId"
        case heName = "DescriptionHe"
        case enName = "EngName"
        case arName = "ArbName"
        case _coordinate = "Location"
        case _isAccessible = "Handicap"
        case _hasParking = "Parking"
        case _paidParking = "ParkingPay"
    }
}
