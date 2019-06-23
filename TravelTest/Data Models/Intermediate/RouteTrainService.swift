//
//  RouteTrainService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct RouteTrainService: Codable  {
    let trainNumber: String
    let origStationId: String
    let destStationId: String
    let destPlatform: String
    let origPlatform: String
    let departureTime: String
    let arrivalTime: String
    let stopStations: RouteStationContainerService?
    
    private enum CodingKeys: String, CodingKey {
        case trainNumber = "Trainno"
        case origStationId = "OrignStation"
        case destStationId = "DestinationStation"
        case destPlatform = "DestPlatform"
        case origPlatform = "Platform"
        case stopStations = "StopStations"
        case departureTime = "DepartureTime"
        case arrivalTime = "ArrivalTime"
    }
}
