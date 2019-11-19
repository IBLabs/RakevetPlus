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
    
    func configure(with station: RouteStation, type: DetailType) {
        self.contentView.backgroundColor = .clear
        self.contentView.superview?.backgroundColor = .clear
        
        self.stationLabel.text = station.station.heName
        self.platformLabel.text = "רציף \(station.platform)"
        
        switch type {
        case .initial:
            self.topLegView.isHidden = true
            self.bottomLegView.isHidden = false
            
            let dotColor = UIColor.colorWithHex(hex: "#0090DA")
            self.dotView.backgroundColor = dotColor
            
            self.dotView.layer.shadowColor = dotColor.cgColor
            self.dotView.layer.shadowOffset = .zero
            self.dotView.layer.shadowRadius = 8
            self.dotView.layer.shadowOpacity = 0.3
            self.dotView.layer.shadowPath = UIBezierPath(ovalIn: self.dotView.bounds).cgPath
            
        case .middle:
            self.topLegView.isHidden = false
            self.bottomLegView.isHidden = false
            self.dotView.backgroundColor = UIColor(white: 0.88, alpha: 1)
            
            self.dotView.layer.shadowColor = nil
            self.dotView.layer.shadowOffset = .zero
            self.dotView.layer.shadowRadius = 0
            self.dotView.layer.shadowOpacity = 0
            self.dotView.layer.shadowPath = nil
            
        case .last:
            self.topLegView.isHidden = false
            self.bottomLegView.isHidden = true
            
            let dotColor = UIColor.colorWithHex(hex: "#FF5200")
            self.dotView.backgroundColor = dotColor
            
            self.dotView.layer.shadowColor = dotColor.cgColor
            self.dotView.layer.shadowOffset = .zero
            self.dotView.layer.shadowRadius = 8
            self.dotView.layer.shadowOpacity = 0.3
            self.dotView.layer.shadowPath = UIBezierPath(ovalIn: self.dotView.bounds).cgPath
        }
    }
    
    enum DetailType {
        case initial
        case last
        case middle
    }
}
