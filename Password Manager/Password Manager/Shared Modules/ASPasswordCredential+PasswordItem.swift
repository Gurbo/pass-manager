//
//  ASPasswordCredential+PasswordItem.swift
//  PasswordManager
//
//  Created by Alex Gurbo on 6/21/21.


import UIKit
import AuthenticationServices

extension ASPasswordCredential {
    
    convenience init(_ passwordItem: Password) {
        self.init(user: passwordItem.user, password: passwordItem.password)
    }
    
}
