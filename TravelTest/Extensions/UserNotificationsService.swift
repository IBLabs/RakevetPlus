//
//  UserNotificationsService.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 24/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit

class UserNotificationsService: NSObject {
    static let shared = UserNotificationsService()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (didSucceed, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("failed to get user notification authorization, \(error.localizedDescription)")
                    NotificationCenter.default.post(name: .userDidDenyNotifications, object: nil)
                } else {
                    if didSucceed {
                        NotificationCenter.default.post(name: .userDidAuthorizeNotifications, object: nil)
                    } else {
                        NotificationCenter.default.post(name: .userDidDenyNotifications, object: nil)
                    }
                }
            }
        }
    }
    
    func hasNotificationsPermission(completion: @escaping ((Bool) -> Void)) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
}

extension UserNotificationsService: UNUserNotificationCenterDelegate {
    
}
