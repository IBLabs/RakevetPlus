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

struct FavouriteRoute: Codable {
    let id: String
    var origStation: TrainStation
    var destStation: TrainStation
    var name: String
    
    init(origStation: TrainStation, destStation: TrainStation, name: String) {
        self.id = UUID().uuidString
        self.origStation = origStation
        self.destStation = destStation
        self.name = name
    }
    
    private init(id: String, origStation: TrainStation, destStation: TrainStation, name: String) {
        self.id = id
        self.origStation = origStation
        self.destStation = destStation
        self.name = name
    }
    
    func updated(origStation: TrainStation? = nil, destStation: TrainStation? = nil, name: String? = nil) -> FavouriteRoute {
        return FavouriteRoute(id: self.id, origStation: origStation ?? self.origStation, destStation: destStation ?? self.destStation, name: name ?? self.name)
    }
}
