//
//  StationResultCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 14/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit

class StationResultCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var altNameLabel: UILabel!
    @IBOutlet weak var handicapIconImageView: UIImageView!
    @IBOutlet weak var parkingIconImageView: UIImageView!
    
    func configure(with station: TrainStation) {
        self.nameLabel.text = station.name
        self.altNameLabel.text = station.altNames.joined(separator: ", ")
        self.parkingIconImageView.isHidden = !station.hasParking
        self.handicapIconImageView.isHidden = !station.isAccessible
    }
}
