//
//  AutofillViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/5/21.
//

import UIKit

class AutofillViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.target = self
        cancelButton.action = #selector(dismissController(sender:))
        self.title = "How to enable Autofill?"

        // Do any additional setup after loading the view.
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
