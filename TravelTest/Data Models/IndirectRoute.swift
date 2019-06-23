//
//  IndirectRoute.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct IndirectRoute {
    let routeTrains: [RouteTrain]
    
    init(service: IndirectRouteService, trains: [String : Train]) {
        var routeTrains = [RouteTrain]()
        for routeTrainService in service.routeTrains {
            guard let train = trains[routeTrainService.trainNumber], let routeTrain = RouteTrain(service: routeTrainService, train: train) else {
                continue
            }
            
            routeTrains.append(routeTrain)
        }
        
        self.routeTrains = routeTrains
    }
}
