//
//  AutofillViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/5/21.
//

import UIKit

class AutofillViewController: UIViewController {
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var autofillLabel: UILabel!
    @IBOutlet weak var switcherLabel: UILabel!
    @IBOutlet weak var appLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.target = self
        cancelButton.action = #selector(dismissController(sender:))
        self.title = "How to enable Autofill?"
        
        
        var appName = "PassKeeper"
        if let strongName = Bundle.main.displayName {
            appName = strongName
        }
    
        
        headerTitleLabel.text = "Activate \(appName) with iOS AutoFill for fast and secure access to all your apps and websites"
        settingsLabel.text = "Go to your device Settings"
        tapLabel.text = "Tap Passwords"
        autofillLabel.text = "Tap on AutoFill Passwords"
        switcherLabel.text = "Turn on Autofill"
        appLabel.text = "Select \(appName)"
        
        self.view.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
        
        
        settingsButton.setGradientBackgroundColor(colors: [UIColor.init(hex: "1461D6"), UIColor.init(hex: "00FFFF")], axis: .horizontal, cornerRadius: 12) { view in
                    guard let settingsButton = view as? UIButton, let imageView = settingsButton.imageView else { return }
            settingsButton.bringSubviewToFront(imageView) // To display imageview of button
        }
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        settingsButton.setTitle("Open Settings", for: .normal)

        
        
        buttonBottomConstraint.constant = 70

        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("5s")
                buttonBottomConstraint.constant = 20
            case 1334:
                print("iPhone 6/6S/7/8/SE2nd")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X/XS/11 Pro")
            case 2688:
                print("iPhone XS Max/11 Pro Max")
            case 1792:
                print("iPhone XR/ 11")
            case 2532:
                print("iPhone_12_12Pro")
            case 2778:
                print("iPhone_12ProMax")
            default:
                print("Unknown")
            }
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
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
