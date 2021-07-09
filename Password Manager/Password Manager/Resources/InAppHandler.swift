//
//  InAppHandler.swift
//  vibro
//
//  Created by Alex Gurbo on 9/13/20.
//  Copyright © 2020 Alex Gurbo. All rights reserved.
//

import Foundation
import Purchases
import Firebase
import Amplitude_iOS

class InAppHandler: NSObject {
    static let shared = InAppHandler()
    var isUserSubscribed: Bool = false
    
    override init() {
        super.init()
    }

    func getAvaiableProducts(offeringName: String, completionHandler: @escaping (Purchases.Offering) -> ()) {
        Purchases.shared.offerings { (offerings, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            if let availableOfferings = offerings {
                if let customOffering = availableOfferings.offering(identifier: offeringName) {
                    Analytics.setUserProperty(offeringName, forName: offeringName)
                    completionHandler(customOffering)
                } else {
                    if let current = offerings?.current {
                        completionHandler(current)
                    } else {
                        print("")
                        //no fucking offerings
                    }
                }
            }
        }
    }
    
    func checkUserSubscription(completionHandler: @escaping (Bool) -> ()) {
        
        let isPaidModeEnabled = RemoteConfigHandler.shared.remoteConfig[paid_mode_enabled].boolValue
        
        if isPaidModeEnabled {
            Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                if let purchaserInfo = purchaserInfo {
                    if (purchaserInfo.activeSubscriptions.count > 0 || !purchaserInfo.nonConsumablePurchases.isEmpty) {
                        self.isUserSubscribed = true
                        UserData.isUserSubscribed = true
                        UserData.shouldShowRater = true
                        
                        let identify = AMPIdentify.init()
                        identify.set("subscribed", value: "true" as NSObject)
                        Amplitude.instance()?.identify(identify)
                        
                        completionHandler(self.isUserSubscribed)
                    } else {
                        self.isUserSubscribed = false
                        UserData.isUserSubscribed = false
                        UserData.shouldShowRater = false
                        
                        let identify = AMPIdentify.init()
                        identify.set("subscribed", value: "false" as NSObject)
                        Amplitude.instance()?.identify(identify)
                        
                        completionHandler(self.isUserSubscribed)
                    }
                    completionHandler(self.isUserSubscribed)
                } else {
                    completionHandler(false)
                }
            }
        } else {
            self.isUserSubscribed = true
            UserData.isUserSubscribed = true
            UserData.shouldShowRater = true
            completionHandler(self.isUserSubscribed)
        }
    }
}
