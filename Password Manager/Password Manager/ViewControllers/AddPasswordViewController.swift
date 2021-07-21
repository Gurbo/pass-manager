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
    
    @IBOutlet weak var copyLoginButton: UIButton!
    @IBOutlet weak var copyPasswordButton: UIButton!
    
    var itemToShow: [String: Any]?
    var serviceToShow: String = ""
    
    @IBOutlet weak var blackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Password"
        
        if let item = itemToShow {
            self.title = "Password"
            
            saveButton.isEnabled = false
            navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
            
            nameTextfield.isEnabled = false
            urlTextfield.isEnabled = false
            loginTextfield.isEnabled = false
            passwordTextfield.isEnabled = false
            
            let keychain = Keychain(service: self.serviceToShow)
            if let attributes = keychain[attributes: (item["key"] as? String)!] {
                nameTextfield.text = attributes.label
            }
            if let password = item["value"] as? String {
                passwordTextfield.text = password
            }
            if let username = item["key"] as? String {
                loginTextfield.text = username
            }
            urlTextfield.text = "https://www.\(serviceToShow)"
            
            copyLoginButton.isHidden = false
            copyPasswordButton.isHidden = false
            copyLoginButton.addTarget(self, action: #selector(copyLogin), for: .touchUpInside)
            copyPasswordButton.addTarget(self, action: #selector(copyPassword), for: .touchUpInside)
        } else {
            nameTextfield.becomeFirstResponder()
            urlTextfield.text = "https://www."
            copyLoginButton.isHidden = true
            copyPasswordButton.isHidden = true
        }
        
        nameTextfield.keyboardType = .alphabet
        urlTextfield.keyboardType = .URL
        loginTextfield.keyboardType = .emailAddress
        passwordTextfield.keyboardType = .alphabet
        
        nameTextfield.autocorrectionType = .no
        urlTextfield.autocorrectionType = .no
        loginTextfield.autocorrectionType = .no
        passwordTextfield.autocorrectionType = .no
        
        nameTextfield.autocapitalizationType = .sentences
        
        
        nameTextfield.attributedPlaceholder = NSAttributedString(string:"Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kSubtitleColor)])
        urlTextfield.attributedPlaceholder = NSAttributedString(string:"Website", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kSubtitleColor)])
        loginTextfield.attributedPlaceholder = NSAttributedString(string:"Login", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kSubtitleColor)])
        passwordTextfield.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kSubtitleColor)])
        
        blackView.isHidden = true
        blackView.alpha = 0.0
        
        nameTextfield.delegate = self
        urlTextfield.delegate = self
        loginTextfield.delegate = self
        passwordTextfield.delegate = self
        
        cancelButton.target = self
        cancelButton.action = #selector(dismissController(sender:))
        
    }
    
    @objc func copyLogin() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = loginTextfield.text
        VibratorEngine.shared.actionTaptic()
    }
    
    @objc func copyPassword() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = passwordTextfield.text
        VibratorEngine.shared.actionTaptic()
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
            && parseDomain(from: urlTextfield.text!).isEmpty == false && parseDomain(from: urlTextfield.text!).isValidURL == true
            && nameTextfield.text?.isEmpty == false
            && loginTextfield.text?.isEmpty == false
            && passwordTextfield.text?.isEmpty == false
    }
    
    private func parseDomain(from string: String) -> String {
        var urlString = string
        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            urlString = "https://" + urlString
        }
        
        let host = URL(string: urlString)?.host?.lowercased() ?? ""
        let components = host.components(separatedBy: ".")
        switch components.count {
        case 0...1:
            return host
        default:
            return components[components.count - 2] + "." + components[components.count - 1]
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let customID = UUID().uuidString
        let keychain: Keychain = Keychain(service: parseDomain(from: urlTextfield.text!)).synchronizable(UserDefaults.forAppGroup.isSyncToICloudEnabled) //website
        do {
            try keychain
                .label(nameTextfield.text!) //service name
                .comment(customID) //id
                .set(passwordTextfield.text!, key: loginTextfield.text!) //login & pass
        } catch let error {
            print("error: \(error)")
        }

        //Saved to autofill
        let password = Password(id: customID, website: parseDomain(from: urlTextfield.text!), user: loginTextfield.text!, password: passwordTextfield.text!, date: Date(), name: nameTextfield.text!)
        password.add()
        
        NotificationCenter.default.post(name: Notification.Name("kUpdateVaultNotification"), object: nil)
        self.dismiss(animated: true, completion: nil)
        

//        self.blackView.isHidden = false
//        UIView.animate(withDuration: 0.0, animations: {
//            self.blackView.alpha = 0.7
//        }) { (finished) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                NotificationCenter.default.post(name: Notification.Name("kUpdateVaultNotification"), object: nil)
//                self.blackView.isHidden = true
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    @objc func dismissController(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
