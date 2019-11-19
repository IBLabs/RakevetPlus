//
//  DirectRouteService.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

struct DirectRouteContainerService: Codable {
    let container: [DirectRouteService]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            let arrayValues = try container.decode([DirectRouteService].self, forKey: .container)
            self.container = arrayValues
        } catch let error {
            print("failed to decode as array, falling back to single object, \(error.localizedDescription)")
            let singleValue = try container.decode(DirectRouteService.self, forKey: .container)
            self.container = [singleValue]
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case container = "Direct"
    }
}

struct DirectRouteService: Codable {
    let  routeTrain: RouteTrainService
    
    private enum CodingKeys: String, CodingKey {
        case routeTrain = "train"
    }
}
