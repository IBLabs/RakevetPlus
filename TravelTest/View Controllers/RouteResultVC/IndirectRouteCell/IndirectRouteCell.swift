//
//  IndirectRouteCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class IndirectRouteCell: UITableViewCell {
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureTimeTitleLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeTitleLabel: UILabel!
    @IBOutlet weak var legCountLabel: UILabel!
    @IBOutlet weak var legCountTitleLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var platformTitleLabel: UILabel!
    @IBOutlet weak private var arrowImageView: UIImageView!
    @IBOutlet weak private var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureStrings()
    }
    
    func configure(with indirectRoute: IndirectRoute) {
        if UIView.userInterfaceLayoutDirection(for: self.arrowImageView.semanticContentAttribute) == .leftToRight {
            self.arrowImageView.transform = .init(scaleX: -1, y: 1)
        }
        
        self.departureTimeLabel.text = indirectRoute.routeTrains.first?.departureTime.toFormat("HH:mm") ?? "--"
        self.arrivalTimeLabel.text = indirectRoute.routeTrains.last?.arrivalTime.toFormat("HH:mm") ?? "--"
        self.platformLabel.text = indirectRoute.routeTrains.first?.origPlatform ?? "--"
        self.legCountLabel.text = "\(indirectRoute.routeTrains.count - 1)"
        self.configureDurationLabel(indirectRoute: indirectRoute)
        
        if indirectRoute.routeTrains.first?.departureTime.isInPast ?? false {
            self.departureTimeLabel.alpha = 0.2
            self.arrivalTimeLabel.alpha = 0.2
            self.platformLabel.alpha = 0.2
            self.legCountLabel.alpha = 0.2
            self.departureTimeTitleLabel.alpha = 0.2
            self.arrivalTimeTitleLabel.alpha = 0.2
            self.legCountTitleLabel.alpha = 0.2
            self.platformTitleLabel.alpha = 0.2
            self.arrowImageView.alpha = 0.2
            self.durationLabel.alpha = 0.2
        } else {
            self.departureTimeLabel.alpha = 1
            self.arrivalTimeLabel.alpha = 1
            self.platformLabel.alpha = 1
            self.legCountLabel.alpha = 1
            self.departureTimeTitleLabel.alpha = 1
            self.arrivalTimeTitleLabel.alpha = 1
            self.legCountTitleLabel.alpha = 1
            self.platformTitleLabel.alpha = 1
            self.arrowImageView.alpha = 1
            self.durationLabel.alpha = 1
        }
    }
    
    private func configureStrings() {
        self.departureTimeTitleLabel.text = NSLocalizedString("שעת יציאה", comment: "שעת יציאה")
        self.arrivalTimeTitleLabel.text = NSLocalizedString("שעת הגעה", comment: "שעת הגעה")
        self.platformTitleLabel.text = NSLocalizedString("רציף", comment: "רציף")
        self.legCountTitleLabel.text = NSLocalizedString("החלפות", comment: "החלפות")
    }
    
    private func configureDurationLabel(indirectRoute: IndirectRoute) {
        let duration = indirectRoute.routeTrains.first?.departureTime.getInterval(toDate: indirectRoute.routeTrains.last?.arrivalTime, component: .minute) ?? 0
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
