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
        var urlString = string
        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            urlString = "https://" + urlString
        }
        return URL(string: urlString)?.host?.lowercased() ?? ""
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        //Saved to Keychain
        let customID = UUID().uuidString
        let keychain: Keychain = Keychain(service: parseDomain(from: urlTextfield.text!)) //website
        do {
            try keychain
                .label(nameTextfield.text!) //service name
                .comment(customID) //id
                .set(passwordTextfield.text!, key: loginTextfield.text!) //login & pass
        } catch let error {
            print("error: \(error)")
        }
        
        //Saved to autofill
        let password = Password(id: customID, website: parseDomain(from: urlTextfield.text!), user: loginTextfield.text!, password: passwordTextfield.text!, date: Date())
        password.add()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("kUpdateVaultNotification"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dismissController(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
