//
//  SearchType.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 19/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation

enum SearchType {
    case origin
    case destination

    func getTitle() -> String {
        switch self {
        case .origin:
            return NSLocalizedString("בחר תחנת מוצא", comment: "בחר תחנת מוצא")
        case .destination:
            return NSLocalizedString("בחר תחנת יעד", comment: "בחר תחנת יעד")
        }
    }
}
