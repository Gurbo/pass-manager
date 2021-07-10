//
//  VaultViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/21/21.
//

import UIKit
import KeychainAccess
import AppLocker

class VaultViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPasswordButton: UIBarButtonItem!
    @IBOutlet weak var emptyTableLabel: UILabel!
    var itemsGroupedByService: [String: [[String: Any]]]?
    var sortedKeys: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PasswordSingletone.shared.grabAllPasswords()
        QuickTypeManager.shared.activate()
        
        self.view.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
        self.tableView.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 102
        self.navigationController?.navigationBar.topItem?.title = "Vault"
        
        emptyTableLabel.text = "Click the “+” at the top right to add a password"
        
        addPasswordButton.target = self
        addPasswordButton.action = #selector(showAddPasswordScreen)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateVaultAfterAddingRecord), name: Notification.Name("kUpdateVaultNotification"), object: nil)
        
        if UserDefaults.forAppGroup.isLocked {
            var options = ALOptions()
            //options.image = UIImage(named: "face")!
            options.title = "Devios Ryasnoy"
            options.color = .green
            options.isSensorsEnabled = UserDefaults.forAppGroup.isFaceIDEnabled
            AppLocker.present(with: .validate, and: options, over: self)
        }
    }
    
    @objc func showAddPasswordScreen(sender:UIButton) {
        let navVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "PasswordNavigationViewController") as PasswordNavigationViewController
        let addPassVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AddPasswordViewController") as AddPasswordViewController
        navVC.viewControllers = [addPassVC]
        self.present(navVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        reloadData()
        tableView.reloadData()
    }
    
    @objc func reloadData() {
        PasswordSingletone.shared.grabAllPasswords()
        self.itemsGroupedByService = PasswordSingletone.shared.itemsGroupedByService
        self.sortedKeys = PasswordSingletone.shared.sortedKeys
        
        emptyTableLabel.isHidden = false
        
        if let keys = sortedKeys, let itemss = itemsGroupedByService {
            if !keys.isEmpty && !itemss.isEmpty {
                emptyTableLabel.isHidden = true
            }
        }
    }
    
    @objc func updateVaultAfterAddingRecord() {
        reloadData()
        tableView.reloadData()
    }
    
    private func showPasscodeScreenIfLocked() {
        guard UserDefaults.forAppGroup.isLocked else {
            return
        }

//        let passcodeNavigationController = PasscodeViewController.instantiate()
//        present(passcodeNavigationController, animated: true, completion: nil)
    }
}

extension VaultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if itemsGroupedByService != nil {
            if sortedKeys != nil {
                return sortedKeys!.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedKeys![section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let service = sortedKeys![section]
        let items = Keychain(service: service).allItems()
        return items.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordItemTableViewCell", for: indexPath) as! PasswordItemTableViewCell
        cell.selectionStyle = .none
    
        let service = sortedKeys![indexPath.section]

        let items = Keychain(service: service).allItems()
        let item = items[indexPath.row]

        let keychain = Keychain(service: service)
        if let attributes = keychain[attributes: (item["key"] as? String)!] {
            cell.itemNameLabel?.text = attributes.label
        }
        cell.usernameLabel?.text = item["key"] as? String
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = sortedKeys![indexPath.section]
        let items = Keychain(service: service).allItems()
        let item = items[indexPath.row]

        let navPassVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "PasswordNavigationViewController") as PasswordNavigationViewController
        let addPassVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AddPasswordViewController") as AddPasswordViewController

        addPassVC.itemToShow = item
        addPassVC.serviceToShow = service
        navPassVC.viewControllers = [addPassVC]
        
        self.present(navPassVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let service = sortedKeys![indexPath.section]

        let keychain = Keychain(service: service)
        let items = keychain.allItems()

        let item = items[indexPath.row] //TRUE ITEM
        let key = item["key"] as! String
        
        var keychainItemIdToDelete = ""
        if let attributes = keychain[attributes: (item["key"] as? String)!] {
            keychainItemIdToDelete = attributes.comment!
        }
        if let autofillPasswords = PasswordSingletone.shared.passwordItems {
            for password in autofillPasswords {
                if password.id == keychainItemIdToDelete {
                    print("")
                    password.delete() //delete from autofill
                }
            }
        }
        keychain[key] = nil
        
        if items.count == 1 {
            reloadData()
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
