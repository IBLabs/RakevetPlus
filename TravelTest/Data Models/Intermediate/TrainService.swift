//
//  TrainService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct TrainContainerService: Codable {
    let container: [TrainService]
    
    private enum CodingKeys: String, CodingKey {
        case container = "Train"
    }
}

struct TrainService: Codable {
    let trainNumber: String
    let stops: [TrainStopService]
    
    private enum CodingKeys: String, CodingKey {
        case trainNumber = "@num"
        case stops = "Station"
    }
}
