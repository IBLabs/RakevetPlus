//
//  RouteCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class DirectRouteCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var trainNameLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    
    func configure(with directRoute: DirectRoute) {
        self.timeLabel.text = directRoute.routeTrain.departureTime.toFormat("HH:mm")
        self.trainNameLabel.text = directRoute.routeTrain.train.stops.last?.station.heName ?? "--"
        self.platformLabel.text = directRoute.routeTrain.origPlatform
    }
}
