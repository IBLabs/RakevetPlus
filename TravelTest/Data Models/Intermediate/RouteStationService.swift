//
//  RouteStationService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct RouteStationContainerService: Codable {
    let container: [RouteStationService]
    
    private enum CodingKeys: String, CodingKey {
        case container = "Station"
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
