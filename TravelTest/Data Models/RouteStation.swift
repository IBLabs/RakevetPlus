//
//  RouteStation.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import SwiftDate

class RouteStation {
    let station: TrainStation
    let arrivalTime: Date
    let departureTime: Date
    let platform: String
    
    init?(service: RouteStationService) {
        guard let arrivalTime = service.arrivalTime.toDate("dd/MM/yyyy HH:mm:ss")?.date,
            let departureTime = service.departureTime.toDate("dd/MM/yyyy HH:mm:ss")?.date,
            let station = DataStore.shared.station(forId: service.id) else {
            return nil
        }
        
        self.station = station
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.platform = service.platform
    }
}
