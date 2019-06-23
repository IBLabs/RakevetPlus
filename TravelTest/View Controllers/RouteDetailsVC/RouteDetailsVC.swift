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
            guard let stopStations = train.stopStations else {
                continue
            }
            
            routeDetails.append(contentsOf: stopStations)
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

extension RouteDetailsVC: UITableViewDataSource {
    var detailCellIdentifier: String { return "co.itamarbiton.TravelTest.DetailCellIdentifier" }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier, for: indexPath)
        
        var detailType: RouteDetailCell.DetailType = .middle
        if let cell = cell as? RouteDetailCell {
            if indexPath.row + 1 > self.routeTrains.count {
                if self.routeTrains[indexPath.row + 1] is TrainSwitch {
                    
                } else {
                    
                }
            } else {
                detailType = .last
            }
        }
        
        return cell
    }
}
