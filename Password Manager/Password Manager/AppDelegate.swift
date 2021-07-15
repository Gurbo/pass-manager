//
//  AppDelegate.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/21/21.
//

import UIKit
import KeychainAccess

import Qonversion
import Amplitude_iOS
import Purchases
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "PNfyAyCundbVAOuSMaVXShvPyDKWyiVl")
        
        Settings.isAutoLogAppEventsEnabled = true
        
        Amplitude.instance()?.initializeApiKey("4e705a46dc403fd5b4ec8d7d0cb8abdf")
        Amplitude.instance()?.trackingSessionEvents = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        let registrationDate = formatter.string(from: Date() as Date)
        
        let identify = AMPIdentify.init()
        identify.setOnce("registrationDate", value: registrationDate as NSObject)
        Amplitude.instance()?.identify(identify)
        
        Qonversion.launch(withKey: "qSG1UO4uInzbUANfILtxUGl7GWpYXYg1") { (result, error) in
           Amplitude.instance()?.setUserId(result.uid)
        }
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
        
//        #warning("УДАЛИТЬ!")
//        UserData.isFirstLaunch = false
//        KeychainNew.logout()

        return true
    }
    
    @objc func applicationDidBecomeActive() {
        QuickTypeManager.shared.updateState()
    }
    
    func purchases(_ purchases: Purchases, didReceiveUpdated purchaserInfo: Purchases.PurchaserInfo) {
        InAppHandler.shared.checkUserSubscription { (isSubscribed) in
        }
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

public class KeychainNew: NSObject {
  public class func logout()  {
    let secItemClasses =  [
      kSecClassGenericPassword,
      kSecClassInternetPassword,
      kSecClassCertificate,
      kSecClassKey,
      kSecClassIdentity,
    ]
    for itemClass in secItemClasses {
      let spec: NSDictionary = [kSecClass: itemClass]
      SecItemDelete(spec)
    }
  }
}

extension Bundle {
    // Name of the app - title under the icon.
    var displayName: String? {
            return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
