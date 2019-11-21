//
//  RemoteConfigService.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 21/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import Foundation
import Firebase

class RemoteConfigService {
    static let shared = RemoteConfigService()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
        // configure settings
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = settings
        
        // set the defaults
        self.remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    func performFetchAndActivate() {
        self.remoteConfig.fetchAndActivate { (status, error) in
            if let error = error {
                print("failed to fetch and activate remote config, \(error.localizedDescription)")
            } else {
                switch status {
                case .successFetchedFromRemote:
                    print("successfully fetched remote config from server")
                case .successUsingPreFetchedData:
                    print("successfully fetched remote config from cache")
                case .error:
                    print("failed to fetch and activate remote config")
                default:
                    break
                }
            }
        }
    }
    
    var additionalKeywords: [String: Array<String>]? {
        let keywordsData = self.remoteConfig["additional_keywords"].dataValue
        let decoder = JSONDecoder()
        do {
            let keywordsDict = try decoder.decode([String: Array<String>].self, from: keywordsData)
            return keywordsDict
        } catch let error {
            print("failed to decode additional keywords, \(error.localizedDescription)")
            return nil
        }
    }
}
