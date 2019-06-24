//
//  TrainSwitchCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 23/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class TrainSwitchCell: UITableViewCell {
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    
    func configure(with trainSwitch: TrainSwitch) {
        self.waitingTimeLabel.text = "\(trainSwitch.waitingTime / 60) דק׳ המתנה"
        self.platformLabel.text = "רציף \(trainSwitch.departurePlatform)"
    }
}
