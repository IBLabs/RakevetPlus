//
//  RecentTripCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 21/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit

class RecentRouteCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var origStationLabel: UILabel!
    @IBOutlet weak var destStationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with recentRoute: RecentRoute, dateFormatter: DateFormatter? = nil) {
        self.origStationLabel.text = recentRoute.origStation.heName
        self.destStationLabel.text = recentRoute.destStation.heName

        var formatter: DateFormatter!
        if dateFormatter != nil {
            formatter = dateFormatter
        } else {
            formatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy H:mm"
                return formatter
            }()
        }

        self.dateLabel.text = formatter.string(from: recentRoute.date)
    }
    
    func performNudgeAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.transform = .init(translationX: -20, y: 0)
        }, completion: { succeeded in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.containerView.transform = .identity
            }, completion: nil)
        })
    }
}

struct RecentRoute: Codable {
    let origStation: TrainStation
    let destStation: TrainStation
    let date: Date
}
