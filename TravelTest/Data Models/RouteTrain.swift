//
//  RouteTrain.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import SwiftDate

struct RouteTrain {
    let train: Train
    let origStation: TrainStation
    let destStation: TrainStation
    let destPlatform: String
    let origPlatform: String
    let arrivalTime: Date
    let departureTime: Date
    let stopStations: [RouteStation]?
    
    public var localizedDepartureTime: DateInRegion {
        let region = Region(calendar: Calendar.current, zone: TimeZone.current, locale: Locale.current)
        return DateInRegion(self.departureTime, region: region)
    }
    
    var origRouteStation: RouteStation {
        get {
            return RouteStation(station: origStation, arrivalTime: departureTime, departureTime: departureTime, platform: origPlatform)
        }
    }
    
    var destRouteStation: RouteStation {
        get {
            return RouteStation(station: destStation, arrivalTime: arrivalTime, departureTime: arrivalTime, platform: destPlatform)
        }
    }
    
    init?(service: RouteTrainService, train: Train) {
        guard let origStation = DataStore.shared.station(forId: service.origStationId),
            let destStation = DataStore.shared.station(forId: service.destStationId),
            let departureTime = service.departureTime.toDate("dd/MM/yyyy HH:mm:ss")?.date,
            let arrivalTime = service.arrivalTime.toDate("dd/MM/yyyy HH:mm:ss")?.date else {
            return nil
        }
        
        self.train = train
        self.origStation = origStation
        self.destStation = destStation
        self.destPlatform = service.destPlatform
        self.origPlatform = service.origPlatform
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        
        if let multipleStations = service.stopStations?.arrayContainer?.compactMap({ RouteStation(service: $0) }) {
            self.stopStations = multipleStations
        } else if let singleStationService = service.stopStations?.singleContainer {
            if let singleStation = RouteStation(service: singleStationService) {
                self.stopStations = [singleStation]
            } else {
                self.stopStations = nil
            }
        } else {
            self.stopStations = nil
        }
    }
}
