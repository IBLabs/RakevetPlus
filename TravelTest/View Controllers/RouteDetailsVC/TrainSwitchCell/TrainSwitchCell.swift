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
    @IBOutlet weak var dashView: UIView!
    
    lazy var dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineDashPattern = [10, 10]
        layer.strokeColor = UIColor.colorWithHex(hex: "#E8E8E8").cgColor
        layer.lineWidth = 4
        layer.lineCap = .round
        
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.dashView.layer.addSublayer(dashLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 0, y: self.dashView.bounds.height))
        self.dashLayer.path = path.cgPath
        dashLayer.frame = self.dashView.bounds
    }
    
    func configure(with trainSwitch: TrainSwitch) {
        self.superview?.clipsToBounds = false
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
        self.dashLayer.masksToBounds = false
        self.dashView.clipsToBounds = false
        self.contentView.superview?.clipsToBounds = false
        
        let waitingTime = trainSwitch.waitingTime / 60
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = false
        let waitingTimeString = numberFormatter.string(from: NSNumber(value: waitingTime)) ?? "--"
        self.waitingTimeLabel.text = "\(waitingTimeString) דק׳"
        self.platformLabel.text = "\(trainSwitch.departurePlatform)"
    }
}
