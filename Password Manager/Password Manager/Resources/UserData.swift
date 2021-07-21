//
//  UserData.swift
//  vibro
//
//  Created by Alex Gurbo on 9/16/20.
//  Copyright © 2020 Alex Gurbo. All rights reserved.
//

import Foundation
import UIKit

struct UserData {
    @Storage(key: "isFirstLaunch", defaultValue: true)
    static var isFirstLaunch: Bool
    
    @Storage(key: "isFirstFilledMapShow", defaultValue: true)
    static var isFirstFilledMapShow: Bool
    
    @Storage(key: "isUserSubscribed", defaultValue: false)
    static var isUserSubscribed: Bool
    
    @Storage(key: "shouldShowRater", defaultValue: false)
    static var shouldShowRater: Bool
    
    @Storage(key: "paywallWasShown", defaultValue: false)
    static var paywallWasShown: Bool
}

@propertyWrapper
struct Storage<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue

        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
