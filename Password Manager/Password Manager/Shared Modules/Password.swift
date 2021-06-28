//
//  Password.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/23/21.
//

import UIKit
import AuthenticationServices

class Password: NSObject {

    var id = UUID().uuidString
    var website = ""
    var user = ""
    var password = ""
    var date = Date()
    
    convenience init(website: String, user: String, password: String, date: Date) {
        self.init()
        self.website = website
        self.user = user
        self.password = password
        self.date = date
    }
    
    // MARK: - Managing PasswordItem
    
    func add() {
        QuickTypeManager.shared.save(ASPasswordCredentialIdentity(self))
    }
    
    func update() {
        QuickTypeManager.shared.remove(ASPasswordCredentialIdentity(self))
        QuickTypeManager.shared.save(ASPasswordCredentialIdentity(self))
    }

    func delete() {
        QuickTypeManager.shared.remove(ASPasswordCredentialIdentity(self))
    }
    
    static func delete(_ items: [Password]) {
        QuickTypeManager.shared.remove(items.map({ ASPasswordCredentialIdentity($0) }))
    }
    
}
