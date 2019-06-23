//
//  IndirectRouteCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit

class IndirectRouteCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var legCountLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    
    func configure(with indirectRoute: IndirectRoute) {
        self.timeLabel.text = indirectRoute.routeTrains.first?.departureTime.toFormat("HH:mm") ?? "--"
        self.platformLabel.text = indirectRoute.routeTrains.first?.origPlatform ?? "--"
        self.legCountLabel.text = "\(indirectRoute.routeTrains.count - 1)"
    }
}
