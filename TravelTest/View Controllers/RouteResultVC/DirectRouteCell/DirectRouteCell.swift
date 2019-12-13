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
    @IBOutlet weak private var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureStrings()
    }

    func configure(with directRoute: DirectRoute) {
        if UIView.userInterfaceLayoutDirection(for: self.arrowImageView.semanticContentAttribute) == .leftToRight {
            self.arrowImageView.transform = .init(scaleX: -1, y: 1)
        }
        
        self.departureTimeLabel.text = directRoute.routeTrain.departureTime.toFormat("HH:mm")
        self.arrivalTimeLabel.text = directRoute.routeTrain.arrivalTime.toFormat("HH:mm")
        self.platformLabel.text = directRoute.routeTrain.origPlatform
        self.configureDurationLabel(directRoute: directRoute)
        
        if directRoute.routeTrain.departureTime.isInPast {
            self.departureTimeLabel.alpha = 0.2
            self.arrivalTimeLabel.alpha = 0.2
            self.platformLabel.alpha = 0.2
            self.departureTimeTitleLabel.alpha = 0.2
            self.arrivalTimeTitleLabel.alpha = 0.2
            self.platformTitleLabel.alpha = 0.2
            self.arrowImageView.alpha = 0.2
            self.durationLabel.alpha = 0.2
        } else {
            self.departureTimeLabel.alpha = 1
            self.arrivalTimeLabel.alpha = 1
            self.platformLabel.alpha = 1
            self.departureTimeTitleLabel.alpha = 1
            self.arrivalTimeTitleLabel.alpha = 1
            self.platformTitleLabel.alpha = 1
            self.arrowImageView.alpha = 1
            self.durationLabel.alpha = 1
        }
    }
    
    private func configureStrings() {
        self.departureTimeTitleLabel.text = NSLocalizedString("שעת יציאה", comment: "שעת יציאה")
        self.arrivalTimeTitleLabel.text = NSLocalizedString("שעת הגעה", comment: "שעת הגעה")
        self.platformTitleLabel.text = NSLocalizedString("רציף", comment: "רציף")
    }
    
    private func configureDurationLabel(directRoute: DirectRoute) {
        let duration = directRoute.routeTrain.departureTime.getInterval(toDate: directRoute.routeTrain.arrivalTime, component: .minute)
        let hours = duration / 60
        let minutes = duration % 60
        var durationString = String(format: NSLocalizedString("%d דק׳", comment: "%d דק׳"), minutes)
        if hours > 0 {
            durationString = String(format: NSLocalizedString("%d שעות, ", comment: "%d שעות, "), hours) + durationString
        }
        self.durationLabel.text = durationString
        self.durationLabel.textColor = self.colorForDuration(duration: duration)
    }
    
    private func colorForDuration(duration: Int64) -> UIColor {
        switch duration {
        case 0..<41:
            return UIColor(red:0.09, green:0.75, blue:0.24, alpha:1.0)
        case 41..<90:
            return UIColor.orange
        case 90..<Int64.max:
            return UIColor.red
        default:
            return UIColor.black
        }
    }
}
