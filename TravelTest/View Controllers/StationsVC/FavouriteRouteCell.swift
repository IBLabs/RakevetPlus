//
//  FavouriteRouteCell.swift
//  TravelTest
//
//  Created by Itamar Biton on 21/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit

class FavouriteRouteCell: UITableViewCell {
    @IBOutlet weak var origStationLabel: UILabel!
    @IBOutlet weak var destStationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with favouriteRoute: FavouriteRoute) {
        self.origStationLabel.text = favouriteRoute.origStation.heName
        self.destStationLabel.text = favouriteRoute.destStation.heName
        self.nameLabel.text = favouriteRoute.name
    }
}

struct FavouriteRoute {
    let origStation: TrainStation
    let destStation: TrainStation
    let name: String
}
