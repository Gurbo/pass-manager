//
//  QuickTypeManager.swift
//  PasswordManager
//
//  Alex Gurbo on 6/21/21.


import UIKit
import AuthenticationServices
import KeychainAccess

class QuickTypeManager: NSObject {
    
    private var observer: Any?
    private var isEnabled = false
    static let shared = QuickTypeManager()
    
    override private init() {}
    
    func activate() {
        updateState()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in
            self.updateState()
        }
    }
    
    func updateState(_ completionHandler: ((Bool) -> Void)? = nil) {
        ASCredentialIdentityStore.shared.getState({ (state) in
            self.isEnabled = state.isEnabled
            
            if self.isEnabled == false {
                return
            }
            
            let passwordItems = PasswordSingletone.shared.passwordItems
            var filteredItems: [Password]?
            
            if state.supportsIncrementalUpdates, let lastSyncDate = UserDefaults.forAppGroup.lastSyncDate {
                filteredItems = passwordItems?.filter({$0.date >= lastSyncDate}) ?? nil
            }
            
            if filteredItems?.count == 0 {
                DispatchQueue.main.async {
                    completionHandler?(true)
                }
                return
            }
            
            let credentialIdentifiers = Array(filteredItems ?? []).map({ ASPasswordCredentialIdentity($0) })
            
            ASCredentialIdentityStore.shared.saveCredentialIdentities(credentialIdentifiers, completion: { (success, error) in
                if let error = error {
                    print(error)
                    
                    DispatchQueue.main.async {
                        completionHandler?(false)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    UserDefaults.forAppGroup.lastSyncDate = Date()
                    completionHandler?(true)
                }
            })
        })
    }
    
    // MARK: - Managing QuicType Sugestion Items
    
    func save(_ credentialIdentity: ASPasswordCredentialIdentity) {
        if isEnabled == false {
            return
        } 
        ASCredentialIdentityStore.shared.saveCredentialIdentities([credentialIdentity]) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }

    func remove(_ credentialIdentity: ASPasswordCredentialIdentity) {
        if isEnabled == false {
            return
        }
        
        ASCredentialIdentityStore.shared.removeCredentialIdentities([credentialIdentity]) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }

    func remove(_ credentialIdentities: [ASPasswordCredentialIdentity]) {
        if isEnabled == false {
            return
        }

        ASCredentialIdentityStore.shared.removeCredentialIdentities(credentialIdentities) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }

}
