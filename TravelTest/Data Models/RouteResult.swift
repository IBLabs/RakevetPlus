
//
//  File.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

class RouteResult {
    let lineType: String
    let lineTypeDescription: String
    let avgTime: String?
    private(set) var directRoutes: [DirectRoute]? = nil
    private(set) var indirectRoutes: [IndirectRoute]? = nil
    private(set) var trains: [String : Train]? = nil
    
    init(service: RouteResultContainerService) {
        self.lineType = service.container.lineType
        self.lineTypeDescription = service.container.lineTypeDescription
        self.avgTime  = service.container.avgTime
        
        let trains = service.container.trains?.container.map { Train(service: $0) }.toDictionary { $0.trainNumber }
        if let trains = trains {
            self.directRoutes = service.container.directRoutes?.container.compactMap { directRouteService -> DirectRoute? in
                let trainNumber = directRouteService.routeTrain.trainNumber
                if let train = trains[trainNumber] {
                    return DirectRoute(service: directRouteService, train: train)
                }
                
                return nil
            }
            self.indirectRoutes = service.container.indirectRoutes?.container.map { IndirectRoute(service: $0, trains: trains) }
            self.trains = trains
        }
    }
}


