//
//  VaultViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/21/21.
//

import UIKit
import KeychainAccess

class VaultViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPasswordButton: UIBarButtonItem!
    var itemsGroupedByService: [String: [[String: Any]]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 102
        self.navigationController?.navigationBar.topItem?.title = "Vault"
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(reloadData), name: Notification.Name("kUpdateVaultNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        reloadData()    
    }
    
    @objc func reloadData() {
        PasswordSingletone.shared.grabAllPasswords()
        
//        let items3 = Keychain.allItems(.genericPassword)
//        print("reloadData \(items3.count)")
//        
        self.itemsGroupedByService = PasswordSingletone.shared.itemsGroupedByService
        self.tableView.reloadData()
    }
}

extension VaultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if itemsGroupedByService != nil {
            let services = Array(itemsGroupedByService!.keys)
            return services.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let services = Array(itemsGroupedByService!.keys)
        return services[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let services = Array(itemsGroupedByService!.keys)
        let service = services[section]

        let items = Keychain(service: service).allItems()
        return items.count
    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordItemTableViewCell", for: indexPath) as! PasswordItemTableViewCell
    cell.selectionStyle = .none
    
    

    let services = Array(itemsGroupedByService!.keys)
    let service = services[indexPath.section]

    let items = Keychain(service: service).allItems()
    let item = items[indexPath.row]

//    let keychain = Keychain(service: service)
//    if let attributes = keychain[attributes: (item["key"] as? String)!] {
//        print(" LABEL  \(attributes.label)")
//        print("CREATEING DATE \(attributes.creationDate)")
//    }
    
    cell.websiteLabel?.text = item["key"] as? String
    cell.usernameLabel?.text = item["value"] as? String
    
    
    return cell
  }
    
    #if swift(>=4.2)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let services = Array(itemsGroupedByService!.keys)
        let service = services[indexPath.section]

        let keychain = Keychain(service: service)
        let items = keychain.allItems()

        let item = items[indexPath.row]
        let key = item["key"] as! String

        keychain[key] = nil

        if items.count == 1 {
            reloadData()
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    #else
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let services = Array(itemsGroupedByService!.keys)
        let service = services[indexPath.section]

        let keychain = Keychain(service: service)
        let items = keychain.allItems()

        let item = items[indexPath.row]
        let key = item["key"] as! String

        keychain[key] = nil

        if items.count == 1 {
            reloadData()
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    #endif
  
}
