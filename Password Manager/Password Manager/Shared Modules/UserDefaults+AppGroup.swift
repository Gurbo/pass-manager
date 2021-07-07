//
//  UserDefaults+AppGroup.swift
//  PasswordManager
//
//  Created by Alex Gurbo on 6/21/21.


import UIKit

let appGroup = "group.com.ag.password.saver"

extension UserDefaults {
    
    var isLocked: Bool {
        get {
            return bool(forKey: "isLocked")
        }
        set {
            set(newValue, forKey: "isLocked")
        }
    }
    
    var isSyncToICloudEnabled: Bool {
        get {
            return bool(forKey: "isSyncToICloudEnabled")
        }
        set {
            set(newValue, forKey: "isSyncToICloudEnabled")
        }
    }
    
    var isAutofillEnabledInSettings: Bool {
        get {
            return bool(forKey: "isAutofillEnabledInSettings")
        }
        set {
            set(newValue, forKey: "isAutofillEnabledInSettings")
        }
    }
    
    var isFaceIDEnabled: Bool {
        get {
            return bool(forKey: "isFaceIDEnabled")
        }
        set {
            set(newValue, forKey: "isFaceIDEnabled")
        }
    }
    
    var lastSyncDate: Date? {
        get {
            return value(forKey: "lastSyncDate") as? Date
        }
        set {
            set(newValue, forKey: "lastSyncDate")
        }
    }
    
    class var forAppGroup: UserDefaults {
        return UserDefaults(suiteName: appGroup)!
    }

}
