//
//  UserDefaults+AppGroup.swift
//  PasswordManager
//
//  Created by Alex Gurbo on 6/21/21.


import UIKit

let appGroup = "group.com.ag.password.manager"

extension UserDefaults {
    
    var isLocked: Bool {
        get {
            return bool(forKey: "isLocked")
        }
        set {
            set(newValue, forKey: "isLocked")
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
