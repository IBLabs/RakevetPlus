//
//  DirectRouteService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct DirectRouteContainerService: Codable {
    let container: [DirectRouteService]
    
    private enum CodingKeys: String, CodingKey {
        case container = "Direct"
    }
}

struct DirectRouteService: Codable {
    let  routeTrain: RouteTrainService
    
    private enum CodingKeys: String, CodingKey {
        case routeTrain = "train"
    }
}
