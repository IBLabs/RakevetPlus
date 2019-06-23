//
//  RouteDetailCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 23/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class RouteDetailCell: UITableViewCell {
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var topLegView: UIView!
    @IBOutlet weak var bottomLegView: UIView!
    @IBOutlet weak var dotView: UIView!
    
    func configure(with trainStop: TrainStop, type: DetailType) {
        self.stationLabel.text = trainStop.station.heName
        self.platformLabel.text = trainStop.arrivalPlatform
        
        switch type {
        case .initial:
            self.topLegView.isHidden = true
            self.bottomLegView.isHidden = false
            self.dotView.backgroundColor = .red
            
        case .middle:
            self.topLegView.isHidden = false
            self.bottomLegView.isHidden = false
            self.dotView.backgroundColor = .lightGray
            
        case .last:
            self.topLegView.isHidden = false
            self.bottomLegView.isHidden = true
            self.dotView.backgroundColor = .red
        }
    }
    
    enum DetailType {
        case initial
        case last
        case middle
    }
}
