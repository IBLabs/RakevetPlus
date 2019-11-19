//
//  RouteResultService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct RouteResultContainerService: Codable {
    let container: RouteResultService
    
    private enum CodingKeys: String, CodingKey {
        case container = "LUZ"
    }
}

struct RouteResultService: Codable {
    let lineType: String
    let lineTypeDescription: String
    let avgTime: String?
    let directRoutes: DirectRouteContainerService?
    let indirectRoutes: IndirectRouteContainerService?
    let trains: TrainContainerService?
    
    private enum CodingKeys: String, CodingKey {
        case lineType = "SugKav"
        case lineTypeDescription = "SugKavDesc"
        case avgTime = "AverageTime"
        case directRoutes = "Directs"
        case trains = "TSD"
        case indirectRoutes = "Indirects"
    }
}
