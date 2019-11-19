//
//  RouteCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class DirectRouteCell: UITableViewCell {
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureTimeTitleLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeTitleLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var platformTitleLabel: UILabel!
    @IBOutlet weak private var arrowImageView: UIImageView!

    func configure(with directRoute: DirectRoute) {
        self.departureTimeLabel.text = directRoute.routeTrain.departureTime.toFormat("HH:mm")
        self.arrivalTimeLabel.text = directRoute.routeTrain.arrivalTime.toFormat("HH:mm")
        self.platformLabel.text = directRoute.routeTrain.origPlatform
        
        if directRoute.routeTrain.departureTime.isInPast {
            self.departureTimeLabel.alpha = 0.2
            self.arrivalTimeLabel.alpha = 0.2
            self.platformLabel.alpha = 0.2
            self.departureTimeTitleLabel.alpha = 0.2
            self.arrivalTimeTitleLabel.alpha = 0.2
            self.platformTitleLabel.alpha = 0.2
            self.arrowImageView.alpha = 0.2
        } else {
            self.departureTimeLabel.alpha = 1
            self.arrivalTimeLabel.alpha = 1
            self.platformLabel.alpha = 1
            self.departureTimeTitleLabel.alpha = 1
            self.arrivalTimeTitleLabel.alpha = 1
            self.platformTitleLabel.alpha = 1
            self.arrowImageView.alpha = 1
        }
    }
}
