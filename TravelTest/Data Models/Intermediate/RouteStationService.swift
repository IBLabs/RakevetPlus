//
//  RouteStationService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct RouteStationContainerService: Codable {
    let arrayContainer: [RouteStationService]?
    let singleContainer: RouteStationService?
    
    init(from decoder: Decoder) throws {
        let arrayValues = try? decoder.container(keyedBy: ArrayCodingKeys.self)
        let singleValue = try? decoder.container(keyedBy: SingleCodingKeys.self)
        
        self.arrayContainer = try? arrayValues?.decode([RouteStationService]?.self, forKey: .arrayContainer)
        self.singleContainer = try? singleValue?.decode(RouteStationService?.self, forKey: .singleContainer)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    private enum ArrayCodingKeys: String, CodingKey {
        case arrayContainer = "Station"
        
    }
    
    private enum SingleCodingKeys: String, CodingKey {
        case singleContainer = "Station"
    }
}

struct RouteStationService: Codable {
    let id: String
    let arrivalTime: String
    let departureTime: String
    let platform: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "StationId"
        case arrivalTime = "ArrivalTime"
        case departureTime = "DepartureTime"
        case platform = "Platform"
    }
}
