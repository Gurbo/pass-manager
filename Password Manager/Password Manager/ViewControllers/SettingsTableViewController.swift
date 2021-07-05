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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        if UserDefaults.forAppGroup.isLocked {
            masterPasswordSwitcher.isOn = true
        } else {
            masterPasswordSwitcher.isOn = false
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func masterPaasswordAction(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                var options = ALOptions()
                //options.image = UIImage(named: "face")!
                options.title = "Devios Ryasnoy"
                options.color = .red
                
                options.isSensorsEnabled = true
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
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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