//
//  IndirectRouteService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct IndirectRouteContainerService: Codable {
    let container: [IndirectRouteService]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            let arrayValues = try container.decode([IndirectRouteService].self, forKey: .container)
            self.container = arrayValues
        } catch let error {
            print("failed to decode as array, falling back to single object, \(error.localizedDescription)")
            let singleValue = try container.decode(IndirectRouteService.self, forKey: .container)
            self.container = [singleValue]
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case container = "Indirect"
    }
}

struct IndirectRouteService: Codable {
    let routeTrains: [RouteTrainService]
    
    private enum CodingKeys: String, CodingKey {
        case routeTrains = "train"
    }
}
