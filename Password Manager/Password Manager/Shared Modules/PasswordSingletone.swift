//
//  PasswordSingletone.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/28/21.
//

import UIKit
import AuthenticationServices
import KeychainAccess

class PasswordSingletone: NSObject {
    
    var itemsGroupedByService: [String: [[String: Any]]]?
    var passwordItems: [Password]?
    var sortedKeys: [String]?
    static let shared = PasswordSingletone()
    override private init() {}
    
    
    func grabAllPasswords() {
        grabPureKeychainItemsForVault()
        passwordItems = [Password]()
        
        if let unwraped = itemsGroupedByService {
            sortedKeys = unwraped.keys.sorted()
        }

        if let items = itemsGroupedByService {
            for (index, _) in items.enumerated() {
                
                let services = Array(itemsGroupedByService!.keys)
                let service = services[index]
                let arrayOfSevenItemsForService = Keychain(service: service).allItems()
            
                for elementOfService in arrayOfSevenItemsForService {
                    var website: String = ""
                    var user: String = ""
                    var password: String = ""
                    var date = Date()
                    var customID = ""
                    var name = ""
                                        
                    for keyValue in elementOfService {
                        if keyValue.key == "service" {
                            website = keyValue.value as! String
                        }
                    
                        if keyValue.key == "key" {
                            user = keyValue.value as! String
                        }
                        
                        if keyValue.key == "value" {
                            password = keyValue.value as! String
                        }
                    }
                    
                    let keychain = Keychain(service: service)
                    if let attributes = keychain[attributes: (elementOfService["key"] as? String)!] {
                        date = attributes.creationDate!
                        customID = attributes.comment! //id
                        name = attributes.label!
                    }
                    
                    let passwordForQuickType = Password.init(id: customID, website: website, user: user, password: password, date: date, name: name)
                    passwordItems?.append(passwordForQuickType)
                }
            }
        }
    }
    
    func allKCItemsShouldSynchronize() {
        grabPureKeychainItemsForVault()
        
        var oldSortedKeys: [String]?
        if let unwraped = itemsGroupedByService {
            oldSortedKeys = unwraped.keys.sorted()
        }

        var passwordToUpdateItems = [Password]()
        
        if let items = itemsGroupedByService {
            for (index, _) in items.enumerated() {
                
                let services = Array(itemsGroupedByService!.keys)
                let service = services[index]
                let arrayOfSevenItemsForService = Keychain(service: service).allItems()
            
                for elementOfService in arrayOfSevenItemsForService {
                    var website: String = ""
                    var user: String = ""
                    var password: String = ""
                    var date = Date()
                    var customID = ""
                    var name = ""
                                        
                    for keyValue in elementOfService {
                        if keyValue.key == "service" {
                            website = keyValue.value as! String
                        }
                    
                        if keyValue.key == "key" {
                            user = keyValue.value as! String
                        }
                        
                        if keyValue.key == "value" {
                            password = keyValue.value as! String
                        }
                    }
                    
                    let keychain = Keychain(service: service)
                    if let attributes = keychain[attributes: (elementOfService["key"] as? String)!] {
                        date = attributes.creationDate!
                        customID = attributes.comment! //id
                        name = attributes.label!
                    }
                    
                    let oldPassword = Password.init(id: customID, website: website, user: user, password: password, date: date, name: name)
                    passwordToUpdateItems.append(oldPassword)
                }
            }
        }
        print("OLD RECORDS COUNT \(passwordToUpdateItems.count)")
        
        
        print("ITEMS COUNT BEFORE DELETE \(Keychain.allItems(.genericPassword).count)")
        
        if let keys = oldSortedKeys {
            for key in keys {
                
                let keychain = Keychain(service: key)
                let newKeys = keychain.allKeys()
                for newKey in newKeys {
                    print("key: \(newKey)")
                    do {
                        try keychain.remove(newKey)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
            }
        }
        
        print("ITEMS COUNT AFTER DELETE \(Keychain.allItems(.genericPassword).count)")
        

        
        for oldPassword in passwordToUpdateItems {
            if let autofillPasswords = PasswordSingletone.shared.passwordItems {
                for password in autofillPasswords {
                    if password.id == oldPassword.id {
                        password.delete() //delete from autofill
                    }
                }
            }
            
            
            
            let customID = UUID().uuidString
            let keychain: Keychain = Keychain(service: oldPassword.website).synchronizable(UserDefaults.forAppGroup.isSyncToICloudEnabled) //website
            do {
                try keychain
                    .label(oldPassword.name) //service name
                    .comment(customID) //id
                    .set(oldPassword.password, key: oldPassword.user) //login & pass
            } catch let error {
                print("error: \(error)")
            }
        }
        
        //NotificationCenter.default.post(name: Notification.Name("kUpdateVaultNotification"), object: nil)
        
        print("ITEMS COUNT AFTER ADDING \(Keychain.allItems(.genericPassword).count)")
        
    }
    
    private func grabPureKeychainItemsForVault() {
        let kcItems = Keychain.allItems(.genericPassword)
        
        itemsGroupedByService = groupBy(kcItems) { item -> String in
            if let service = item["service"] as? String {
                return service
            }
            return ""
        }
        print("")
    }
    
    private func groupBy<C: Collection, K: Hashable>(_ xs: C, key: (C.Iterator.Element) -> K) -> [K:[C.Iterator.Element]] {
        var gs: [K:[C.Iterator.Element]] = [:]
        for x in xs {
            let k = key(x)
            
            if let stringToValidate = k as? String {
                if stringToValidate.isValidURL {
                    var ys = gs[k] ?? []
                    ys.append(x)
                    gs.updateValue(ys, forKey: k)
                }
            }
        }
        return gs
    }
}


extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
