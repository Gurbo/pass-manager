//
//  MasterPasswordViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/4/21.
//

import UIKit

class MasterPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstPasswordTextfield: UITextField!
    @IBOutlet weak var secondPasswordTextfield: UITextField!
    @IBOutlet weak var thirdPasswordTextfield: UITextField!
    @IBOutlet weak var fourthPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPasswordTextfield.delegate = self
        secondPasswordTextfield.delegate = self
        thirdPasswordTextfield.delegate = self
        fourthPasswordTextfield.delegate = self
        
        firstPasswordTextfield.keyboardType = .numberPad
        secondPasswordTextfield.keyboardType = .numberPad
        thirdPasswordTextfield.keyboardType = .numberPad
        fourthPasswordTextfield.keyboardType = .numberPad
        
        firstPasswordTextfield.textAlignment = .center
        secondPasswordTextfield.textAlignment = .center
        thirdPasswordTextfield.textAlignment = .center
        fourthPasswordTextfield.textAlignment = .center
        
        firstPasswordTextfield.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstPasswordTextfield {
            secondPasswordTextfield.becomeFirstResponder()
        } else if textField == secondPasswordTextfield {
            thirdPasswordTextfield.becomeFirstResponder()
        } else if textField == thirdPasswordTextfield {
            fourthPasswordTextfield.becomeFirstResponder()
        }
        return true
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
