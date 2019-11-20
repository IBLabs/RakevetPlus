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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lineType = try container.decode(String.self, forKey: .lineType)
        self.lineTypeDescription = try container.decode(String.self, forKey: .lineTypeDescription)
        self.avgTime = try? container.decode(String.self, forKey: .avgTime)
        self.directRoutes = try? container.decode(DirectRouteContainerService.self, forKey: .directRoutes)
        self.indirectRoutes = try? container.decode(IndirectRouteContainerService.self, forKey: .indirectRoutes)
        self.trains = try? container.decode(TrainContainerService.self, forKey: .trains)
    }

    private enum CodingKeys: String, CodingKey {
        case lineType = "SugKav"
        case lineTypeDescription = "SugKavDesc"
        case avgTime = "AverageTime"
        case directRoutes = "Directs"
        case trains = "TSD"
        case indirectRoutes = "Indirects"
    }
}
