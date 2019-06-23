//
//  IndirectRouteService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct IndirectRouteContainerService: Codable {
    let container: [IndirectRouteService]
    
    private enum CodingKeys: String, CodingKey {
        case container = "Indirect"
    }
}

struct IndirectRouteService: Codable {
    let routeTrains: [RouteTrainService]
    
    private enum CodingKeys: String, CodingKey {
        case routeTrains = "train"
    }
}
