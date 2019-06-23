//
//  TrainStop.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

class TrainStop {
    let station: TrainStation
    let arrivalPlatform: String
    let arrivalTime: String
    let load: Double
    
    init?(service: TrainStopService) {
        guard let station = DataStore.shared.station(forId: service.stationId) else {
            return nil
        }
        
        self.station = station
        self.arrivalPlatform = service.arrivalPlatform
        self.arrivalTime = service.arrivalTime
        self.load = Double(service.load) ?? -1
    }
}
