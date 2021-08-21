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
import FBAudienceNetwork
import SwiftRater
import AppsFlyerLib
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        AppsFlyerLib.shared().appsFlyerDevKey = "StyaLXDGpiyHnEmfptygBj"
        AppsFlyerLib.shared().appleAppID = "1575742112"
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 80)
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = true
               // iOS 10 or later
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
            application.registerForRemoteNotifications()
        }
               // iOS 9 support - Given for reference. This demo app supports iOS 13 and above
        else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            application.registerForRemoteNotifications()
        }
        
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FBAudienceNetworkAds.initialize(with: nil, completionHandler: nil)
        
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
        
        setRater()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(appnDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
        
//        #warning("УДАЛИТЬ!")
//        UserData.isFirstLaunch = false
//        KeychainNew.logout()

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
           // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
        print("FUCK FUCK AppsFlyerLib.shared().start()")
           AppsFlyerLib.shared().start()
       }
    
    @objc func sendLaunch() {
        print("FUCK Kind AppsFlyerLib.shared().start()")
            AppsFlyerLib.shared().start()
        }
    
    // Open Univerasal Links
     // For Swift version < 4.2 replace function signature with the commented out code:
     // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
         print(" user info \(userInfo)")
         AppsFlyerLib.shared().handlePushNotification(userInfo)
     }
    
    // Open Deeplinks
    // Open URI-scheme for iOS 8 and below
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: restorationHandler)
        return true
    }
    
    // Open URI-scheme for iOS 9 and above
        func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
            AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
            return true
        }
    
    // Report Push Notification attribution data for re-engagements
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            AppsFlyerLib.shared().handleOpen(url, options: options)
            return true
        }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            AppsFlyerLib.shared().handlePushNotification(userInfo)
        }
    
    // Reports app open from deep link for iOS 10 or later
        func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
            AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
            return true
        }
    
    func setRater() {
        SwiftRater.significantUsesUntilPrompt = 0
        SwiftRater.daysBeforeReminding = 5
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false
        SwiftRater.appID = "1575742112"
        SwiftRater.appLaunched()
    }
    
    @objc func appnDidBecomeActive() {
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

//MARK: AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate{
    
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                    let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
                is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    func onConversionDataFail(_ error: Error) {
        print("HERE HERE HERE")
        print(error)
    }
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print("HERE HERE HERE 111")
        print(error)
    }
}
