//
//  LocalNotificationsService.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 27/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class LocalNotificationsService {
    static let shared = LocalNotificationsService()
    
    func addTrainReminder(targetDate: Date, minutesBefore: Int) {
        guard !targetDate.isInPast else {
            return
        }
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("הרכבת שלך יוצאת בקרוב", comment: "הרכבת שלך יוצאת בקרוב")
        content.body = NSLocalizedString("הרכבת שלך יוצאת בדקות הקרובות, זה הזמן לצאת לתחנה", comment: "הרכבת שלך יוצאת בדקות הקרובות, זה הזמן לצאת לתחנה")
        content.sound = UNNotificationSound.default
        
        let timeInterval = targetDate.timeIntervalSinceNow - minutesBefore.minutes.timeInterval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("failed to schedule local notification, \(error.localizedDescription)")
            }
        }
    }
}
