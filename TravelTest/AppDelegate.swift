//
//  AppDelegate.swift
//  TravelTest
//
//  Created by Itamar Biton on 14/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit
import SwiftDate
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // create a window
        window = UIWindow(frame: UIScreen.main.bounds)

        // configure firebase
        FirebaseApp.configure()

        // sign the user in anonymously
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("failed to sign in, \(error.localizedDescription)")
            } else {
                print("successfully signed in!")
            }
        }

        // configure the default region for SwiftDate
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaJerusalem, locale: Locales.hebrewIsrael)
        SwiftDate.defaultRegion = region

        let stationsVC = StationsVC()
        let navigationController = UINavigationController(rootViewController: stationsVC)
        navigationController.isNavigationBarHidden = true
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

