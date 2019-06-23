//
//  Train.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

class Train {
    let trainNumber: String
    let stops: [TrainStop]
    
    init(service: TrainService) {
        self.trainNumber = service.trainNumber
        self.stops = service.stops.compactMap { TrainStop(service: $0) }
    }
}
