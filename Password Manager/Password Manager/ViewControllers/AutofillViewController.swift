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
