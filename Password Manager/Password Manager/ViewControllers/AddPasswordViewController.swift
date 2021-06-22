//
//  AddPasswordViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/21/21.
//

import UIKit
import KeychainAccess

class AddPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var urlTextfield: UITextField!
    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Password"
        
        nameTextfield.delegate = self
        urlTextfield.delegate = self
        loginTextfield.delegate = self
        passwordTextfield.delegate = self
        
        cancelButton.target = self
        cancelButton.action = #selector(dismissController(sender:))
        nameTextfield.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextfield {
            urlTextfield.becomeFirstResponder()
        } else if textField == urlTextfield {
            loginTextfield.becomeFirstResponder()
        } else if textField == loginTextfield {
            passwordTextfield.becomeFirstResponder()
        }  else {
            if saveButton.isEnabled {
                saveTapped(saveButton as Any)
            }
        }
        return true
    }
    
    @IBAction func fieldEditingChanged(_ sender: Any) {
        saveButton.isEnabled = urlTextfield.text?.isEmpty == false
            && parseDomain(from: urlTextfield.text!).isEmpty == false
            && nameTextfield.text?.isEmpty == false
            && loginTextfield.text?.isEmpty == false
            && passwordTextfield.text?.isEmpty == false
    }
    
    private func parseDomain(from string: String) -> String {
        // This method performs a simple domain check.
        // If you want to check the domain more strictly, please use the following library
        // https://github.com/Dashlane/SwiftDomainParser
        
        var urlString = string

        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            urlString = "https://" + urlString
        }
        
        return URL(string: urlString)?.host ?? ""
    }
    
    private func addPasswordItem(website: String, user: String, password: String) {
//        let passwordItem = PasswordItem(website: website, user: user, password: password)
//        passwordItem.add()
//        
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
//        let keychain: Keychain = Keychain.init(accessGroup: accessGroup)
//        keychain[kName] = nameTextfield.text!
//        keychain[kWebsite] = parseDomain(from: urlTextfield.text!)
//        keychain[kLogin] = loginTextfield.text!
//        keychain[kPassword] = passwordTextfield.text!
        
        
        
       

        let keychain: Keychain = Keychain(service: parseDomain(from: urlTextfield.text!))
        do {
            try keychain
                .label(nameTextfield.text!)
                .comment(nameTextfield.text!)
                .set(loginTextfield.text!, key: passwordTextfield.text!)
        } catch let error {
            print("error: \(error)")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("kUpdateVaultNotification"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        
        

        

        
        
//        addPasswordItem(website: parseDomain(from: websiteField.text!),
//                        user: userField.text!,
//                        password: passwordField.text!)
    }
    
    @objc func dismissController(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
