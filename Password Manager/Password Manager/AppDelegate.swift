//
//  AppDelegate.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/21/21.
//

import UIKit
import KeychainAccess

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let keychain = Keychain(service: "url.com")

        let items = keychain.allItems()
        for item in items {
          print("item: \(item)")
        }
        
//        let keychain2 = Keychain(service: "url888.com")
//
//        let items2 = keychain2.allItems()
//        for item in items2 {
//          print("item: \(item)")
//        }
        // Override point for customization after application launch.
        
//        let keychain = Keychain.init(accessGroup: accessGroup)
//        print("\(keychain)")
//
//
//        let keys = keychain.allKeys()
//        for key in keys {
//          print("key: \(key)")
//        }
//
//        let items = keychain.allItems()
//        for item in items {
//          print("item: \(item)")
//        }
//
//        do {
//            try Keychain.init(accessGroup: accessGroup).removeAll()
//        } catch let error {
//           // Manager.log.error("Failed to remove all keychains with error: \(error)")
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

