//
//  Array+ToDictionary.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key : Element] {
        var dict = [Key : Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        
        return dict
    }
}
