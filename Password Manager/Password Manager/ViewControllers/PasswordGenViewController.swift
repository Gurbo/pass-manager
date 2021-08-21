//
//  PasswordGenViewController.swift
//  Password Manager
//
//  Created by Alex on 21.08.21.
//

import UIKit

class PasswordGenViewController: UIViewController {
    
    @IBOutlet weak var topLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var copyButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var lowerCaseLabel: UILabel!
    @IBOutlet weak var upperCaseLabel: UILabel!
    @IBOutlet weak var numbersLabel: UILabel!
    @IBOutlet weak var symbolsLabel: UILabel!
    
    @IBOutlet weak var lowerCaseSwitch: UISwitch!
    @IBOutlet weak var upperCaseSwitch: UISwitch!
    @IBOutlet weak var numbersSwitch: UISwitch!
    @IBOutlet weak var symbolsSwitch: UISwitch!
    
    @IBOutlet weak var passwordLengthLabel: UILabel!
    @IBOutlet weak var passwordLengthSlider: UISlider!
    
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
    var passwordCharactersCount = 10
    
    let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "1234567890"
    let symbols = "!@#$%^&*()[]{};?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
        self.navigationController?.navigationBar.topItem?.title = "Password Generator"
        
        passwordLabel.adjustsFontSizeToFitWidth = true
        
        passwordLengthLabel.text = "Password Length: \(passwordCharactersCount)"
        passwordLengthSlider.setValue(Float(passwordCharactersCount), animated: true)
        
        passwordLabel.layer.cornerRadius = 10.0
        passwordLabel.layer.masksToBounds = true
        generateButton.layer.cornerRadius = 10.0
        copyButton.layer.cornerRadius = 10.0
        passwordLengthSlider.thumbTintColor = UIColor.white
        passwordLengthSlider.minimumTrackTintColor = UIColor.init(hex: kMintColor)
        
        generateRandomString()
        
        generateButton.addTarget(self, action: #selector(generateRandomString), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyPassword), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("5s")
                topLabelConstraint.constant = 0
                copyButtonBottomConstraint.constant = 2
                self.navigationItem.largeTitleDisplayMode = .automatic
                self.navigationController?.navigationBar.prefersLargeTitles = false
            case 1334:
                print("iPhone 6/6S/7/8/SE2nd")
                self.navigationItem.largeTitleDisplayMode = .automatic
                self.navigationController?.navigationBar.prefersLargeTitles = false
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X/XS/11 Pro")
            case 2688:
                print("iPhone XS Max/11 Pro Max")
            case 1792:
                print("iPhone XR/ 11")
        case 2340: //2436
            print("iPhone 12 Mini")
            
        case 2532:
            print("iPhone 12 / 12 Pro")
        case 2778:
            print("iPhone 12 Pro Max")
            default:
                print("Unknown")
            }
        }
    }
    
    @IBAction private func passwordSliderDidMove(_ sender: UISlider) {
        VibratorEngine.shared.sliderTaptic()
        passwordCharactersCount = Int(passwordLengthSlider.value)
        passwordLengthLabel.text = "Password Length: \(passwordCharactersCount)"
    }
    
    @objc func copyPassword() {
        VibratorEngine.shared.actionTaptic()
        let pasteboard = UIPasteboard.general
        pasteboard.string = passwordLabel.text
    }
    
    @objc func generateRandomString() {
        VibratorEngine.shared.actionTaptic()
        var letters = ""
        
        if lowerCaseSwitch.isOn {
            letters = letters + lowercaseLetters
        }
        
        if upperCaseSwitch.isOn {
            letters = letters + uppercaseLetters
        }
        
        if numbersSwitch.isOn {
            letters = letters + numbers
        }
        
        if symbolsSwitch.isOn {
            letters = letters + symbols
        }
        
        if letters == "" {
            let alert = UIAlertController(title: "Error", message: "You need at least one attribute selected to generate a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        let newPassword =  String((0..<passwordCharactersCount).map{ _ in letters.randomElement()! })
        passwordLabel.text = newPassword
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
