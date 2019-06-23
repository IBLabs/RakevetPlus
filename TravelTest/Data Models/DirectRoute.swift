//
//  DirectRoute.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

class DirectRoute {
    let routeTrain: RouteTrain
    
    init?(service: DirectRouteService, train: Train) {
        guard let routeTrain = RouteTrain(service: service.routeTrain, train: train) else {
            return nil
        }
        
        self.routeTrain = routeTrain
    }
}
