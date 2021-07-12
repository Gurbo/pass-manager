//
//  SettingsTableViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/2/21.
//

import UIKit
import AppLocker

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
                #warning("INSERT ALERT TEXT - 1 iCLOUD FOR ALL DEVICES")
                UserDefaults.forAppGroup.isSyncToICloudEnabled = true
            } else {
                UserDefaults.forAppGroup.isSyncToICloudEnabled = false
            }
            PasswordSingletone.shared.allKCItemsShouldSynchronize()
        }
    }
    
    @IBAction func faceIDSwitcherAction(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                //включили в ON
                if UserDefaults.forAppGroup.isLocked {
                    UserDefaults.forAppGroup.isFaceIDEnabled = true
                } else {
                    UserDefaults.forAppGroup.isFaceIDEnabled = false
                    updateSwitcherStates()
                    let alert = UIAlertController(title: "First enable master password", message: "First enable master password", preferredStyle: .alert)
                         let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                         })
                         alert.addAction(ok)
                         DispatchQueue.main.async(execute: {
                            self.present(alert, animated: true)
                    })
                }
            } else {
                UserDefaults.forAppGroup.isFaceIDEnabled = false
            }
        }
    }
    
    @IBAction func autofillSwitcherAction(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                switcher.isOn = false
                let navVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AutofillNavigationViewController") as AutofillNavigationViewController
                let addPassVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AutofillViewController") as AutofillViewController
                navVC.viewControllers = [addPassVC]
                self.present(navVC, animated: true, completion: nil)
            } else {
                switcher.isOn = true
                let alert = UIAlertController(title: "!!!!", message: "To turn off Autofill - Settings -> Passwords -> Autofill -> Uncheck ", preferredStyle: .alert)
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
                var options = ALOptions()
                //options.image = UIImage(named: "face")!
                options.title = "Devios Ryasnoy"
                options.color = .red
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
                UserDefaults.forAppGroup.isLocked = false
                UserDefaults.forAppGroup.isFaceIDEnabled = false
                updateSwitcherStates()
            }
        }
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

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
