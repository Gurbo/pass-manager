//
//  SettingsTableViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/2/21.
//

import UIKit
import Amplitude_iOS

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var masterPasswordSwitcher: UISwitch!
    @IBOutlet weak var faceIDSwitcher: UISwitch!
    @IBOutlet weak var autofillSwitcher: UISwitch!
    @IBOutlet weak var syncSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(updateSwitcherStates),
            name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
        
        
        self.view.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
        self.tableView.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
        
        masterPasswordSwitcher.onTintColor = UIColor.init(hex: kMintColor)
        faceIDSwitcher.onTintColor = UIColor.init(hex: kMintColor)
        autofillSwitcher.onTintColor = UIColor.init(hex: kMintColor)
        syncSwitcher.onTintColor = UIColor.init(hex: kMintColor)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(updateUIAfterPurchase), name: NSNotification.Name(rawValue: "updateUIAfterPurchase"), object: nil)
    }
    
//    @objc func updateUIAfterPurchase() {
//
//    }
    
    @IBAction func eraseAll(_ sender: Any) {
        let alert = UIAlertController(title: "Attention!", message: "All passwords that you created in the app will be deleted from your device and will not be available for autofill on websites.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "I understand", style: .default, handler: { action in
            KeychainNew.logout()
            
            let alert = UIAlertController(title: "", message: "All your passwords were successfully deleted", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: { action in

            })
            alert.addAction(cancelAction)
            DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true)
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in

        })
        
        alert.addAction(ok)
        alert.addAction(cancelAction)
            
        DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
        })
    }
    
    
    @objc func updateSwitcherStates() {
        DispatchQueue.main.async {
            if UserDefaults.forAppGroup.isLocked {
                self.masterPasswordSwitcher.isOn = true
            } else {
                self.masterPasswordSwitcher.isOn = false
            }
            
            if UserDefaults.forAppGroup.isSyncToICloudEnabled {
                self.syncSwitcher.isOn = true
            } else {
                self.syncSwitcher.isOn = false
            }
            
            if UserDefaults.forAppGroup.isFaceIDEnabled {
                self.faceIDSwitcher.isOn = true
            } else {
                self.faceIDSwitcher.isOn = false
            }

            if UserDefaults.forAppGroup.isAutofillEnabledInSettings {
                self.autofillSwitcher.isOn = true
            } else {
                self.autofillSwitcher.isOn = false
            }
        }
    }
    
    @IBAction func syncSwitcherAction(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                if UserData.isUserSubscribed {
                    let alert = UIAlertController(title: "Attention!", message: "All your passwords will be synced between your devices with the same iCloud account (as your current iCloud account on your device).", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                        UserDefaults.forAppGroup.isSyncToICloudEnabled = true
                        PasswordSingletone.shared.allKCItemsShouldSynchronize()
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                        alert.dismiss(animated: true, completion: nil)
                        UserDefaults.forAppGroup.isSyncToICloudEnabled = false
                    })
                    
                    alert.addAction(ok)
                    alert.addAction(cancelAction)
                        
                    DispatchQueue.main.async(execute: {
                            self.present(alert, animated: true)
                    })
                } else {
                    switcher.isOn = false
                    showPaywall()
                }
            } else {
                UserDefaults.forAppGroup.isSyncToICloudEnabled = false
            }
        }
    }
    
    @IBAction func faceIDSwitcherAction(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                if UserData.isUserSubscribed {
                    if UserDefaults.forAppGroup.isLocked {
                        UserDefaults.forAppGroup.isFaceIDEnabled = true
                    } else {
                        UserDefaults.forAppGroup.isFaceIDEnabled = false
                        updateSwitcherStates()
                        let alert = UIAlertController(title: "Attention!", message: "You must first enable the Master Password", preferredStyle: .alert)
                             let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                             })
                             alert.addAction(ok)
                             DispatchQueue.main.async(execute: {
                                self.present(alert, animated: true)
                        })
                    }
                } else {
                    switcher.isOn = false
                    Amplitude.instance()?.logEvent("paywall_app_face_show")
                    showPaywall()
                }
            } else {
                UserDefaults.forAppGroup.isFaceIDEnabled = false
            }
        }
    }
    
    @IBAction func autofillSwitcherAction(_ sender: Any) {
        
//        #warning("DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE")
//        UserData.isUserSubscribed = true
        
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                switcher.isOn = false
                if UserData.isUserSubscribed {
                    let navVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AutofillNavigationViewController") as AutofillNavigationViewController
                    let addPassVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AutofillViewController") as AutofillViewController
                    navVC.viewControllers = [addPassVC]
                    self.present(navVC, animated: true, completion: nil)
                } else {
                    Amplitude.instance()?.logEvent("paywall_app_autofill_show")
                    showPaywall()
                }
            } else {
                switcher.isOn = true
                
                var appName = "iPassword"
                if let strongName = Bundle.main.displayName {
                    appName = strongName
                }
                
                let alert = UIAlertController(title: "Attention!", message: "To turn off Websites Autofill open your device Settings -> Passwords -> AutoFill Passwords -> Tap the \(appName) icon", preferredStyle: .alert)
                     let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                     })
                     alert.addAction(ok)
                     DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true)
                })
            }
        }
    }
    
    @IBAction func masterPaasswordAction(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                if UserData.isUserSubscribed {
                    var options = ALOptions()
                    options.image = UIImage(named: "onb_lockx")!
                    options.subtitle = "Create your new Master Password"
                    options.color = UIColor.init(hex: kBlackBackgroundColor)
                    options.onSuccessfulDismiss = { (mode: ALMode?) in
                        if let _ = mode {
                            UserDefaults.forAppGroup.isLocked = true
                            self.masterPasswordSwitcher.isOn = true
                        } else {
                            UserDefaults.forAppGroup.isLocked = false
                            self.masterPasswordSwitcher.isOn = false
                        }
                    }
                    options.onFailedAttempt = { (mode: ALMode?) in
                        UserDefaults.forAppGroup.isLocked = false
                        self.masterPasswordSwitcher.isOn = false
                    }
                    AppLocker.present(with: .create, and: options, over: self)
                } else {
                    Amplitude.instance()?.logEvent("paywall_app_password_show")
                    self.masterPasswordSwitcher.isOn = false
                    showPaywall()
                }
            } else {
                UserDefaults.forAppGroup.isLocked = false
                UserDefaults.forAppGroup.isFaceIDEnabled = false
                updateSwitcherStates()
            }
        }
    }
    
    func showPaywall() {
        let vc = SubscriptionViewController.instantiate()
        self.navigationController?.present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSwitcherStates()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
}
