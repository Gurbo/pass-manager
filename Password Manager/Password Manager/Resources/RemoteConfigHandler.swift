//
//  RemoteConfigHandler.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/9/21.
//

import Foundation
import Firebase

class RemoteConfigHandler: NSObject {
    
    var remoteConfig: RemoteConfig!
    static let shared = RemoteConfigHandler()
    
    override init() {
        super.init()
    }
    
    func setupRemoteConfig() {
      remoteConfig = RemoteConfig.remoteConfig()
      remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")

      let settings = RemoteConfigSettings()
      settings.minimumFetchInterval = 0
      remoteConfig.configSettings = settings
    }
    
    func fetchAndActivateRemoteConfig(completionHandler: @escaping (RemoteConfigFetchAndActivateStatus) -> ()) {
        print("FETCH START  \(Date())")
        remoteConfig.fetchAndActivate { (status, error) in
            print("FETCH FINISHED  \(Date())")
            completionHandler(status)
        }
    }
}


