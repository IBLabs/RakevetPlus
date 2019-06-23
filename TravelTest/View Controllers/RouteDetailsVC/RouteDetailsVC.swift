//
//  RouteDetailsVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 22/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit
import SwiftDate

class RouteDetailsVC: UIViewController {
    
    var routeTrains = [RouteTrain]()

    @IBOutlet weak private var routeTableView: UITableView!
    
    private var routeDetails = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeRouteDetails()
    }
    
    private func initializeRouteDetails() {
        var routeDetails = [Any]()
        
        for (index, train) in self.routeTrains.enumerated() {
            routeDetails.append(train)
            if index + 1 < self.routeTrains.count {
                let nextTrain = self.routeTrains[index + 1]
                let trainSwitch = TrainSwitch(arrivalTime: train.arrivalTime, departureTime: nextTrain.departureTime, arrivalPlatform: train.destPlatform, departurePlatform: nextTrain.origPlatform)
                routeDetails.append(trainSwitch)
            }
        }
        
        self.routeDetails = routeDetails
    }

}

struct TrainSwitch {
    let arrivalTime: Date
    let departureTime: Date
    let arrivalPlatform: String
    let departurePlatform: String
    
    var waitingTime: TimeInterval {
        return self.departureTime.timeIntervalSince(self.arrivalTime)
    }
}
