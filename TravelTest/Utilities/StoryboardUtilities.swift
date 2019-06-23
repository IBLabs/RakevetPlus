//
//  StoryboardUtilities.swift
//  TravelTest
//
//  Created by Itamar Biton on 17/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit

class StoryboardUtilities {
    static func instantiateFromMainStoryboard(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

struct ViewControllerIdentifiers {
    static let stationsMap = "co.climacell.TravelTest.StationsMapVCIdentifier"
    static let searchStations = "co.climacell.TravelTest.SearchStationsVCIdentifier"
}
