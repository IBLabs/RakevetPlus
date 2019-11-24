//
//  PermissionInteractionController.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 24/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit

class PermissionInteractionController: UIViewController {
    var parentPermissionContainerVC: PermissionContainerVC?
    
    final func finish() {
        self.parentPermissionContainerVC?.permissionInterfaceControllerDidFinish(permissionIC: self)
    }
}
