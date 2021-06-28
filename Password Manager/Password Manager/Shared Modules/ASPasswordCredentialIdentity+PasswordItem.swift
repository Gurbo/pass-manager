//
//  ASPasswordCredentialIdentity+PasswordItem.swift
//  PasswordManager
//
//  Created by Alex Gurbo on 6/21/21.


import UIKit
import AuthenticationServices

extension ASPasswordCredentialIdentity {
    
    convenience init(_ passwordItem: Password) {
        let serviceIdentifier = ASCredentialServiceIdentifier(identifier: passwordItem.website,
                                                              type: .domain)
        self.init(serviceIdentifier: serviceIdentifier,
                  user: passwordItem.user,
                  recordIdentifier: passwordItem.id)
    }
    
}
