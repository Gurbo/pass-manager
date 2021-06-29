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
    static let shared = PasswordSingletone()
    override private init() {}
    
    
    func grabAllPasswords() {
        let kcItems = Keychain.allItems(.genericPassword)
        
        itemsGroupedByService = groupBy(kcItems) { item -> String in
            if let service = item["service"] as? String {
                return service
            }
            return ""
        }
        
        passwordItems = [Password]()
        
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
                        
                    }
                    
                    let passwordForQuickType = Password.init(id: customID, website: website, user: user, password: password, date: date)
                    passwordItems?.append(passwordForQuickType)
                }
            }
        }
        print("Grab passwords finished")
    }
    
    private func groupBy<C: Collection, K: Hashable>(_ xs: C, key: (C.Iterator.Element) -> K) -> [K:[C.Iterator.Element]] {
        var gs: [K:[C.Iterator.Element]] = [:]
        for x in xs {
            let k = key(x)
            var ys = gs[k] ?? []
            ys.append(x)
            gs.updateValue(ys, forKey: k)
        }
        return gs
    }
}
