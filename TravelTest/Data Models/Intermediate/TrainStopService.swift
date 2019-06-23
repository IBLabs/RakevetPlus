//
//  TrainStopService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct TrainStopService: Codable {
    let stationId: String
    let arrivalPlatform: String
    let arrivalTime: String
    let load: String
    
    private enum CodingKeys: String, CodingKey {
        case stationId = "@Num"
        case arrivalPlatform = "@Platform"
        case arrivalTime = "@Time"
        case load = "@Omes"
        
    }
}
