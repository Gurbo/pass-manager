//
//  OnboardingFirstViewController.swift
//  BluetoothScanner
//
//  Created by Alex Gurbo on 5/22/21.
//  Copyright © 2021 AG. All rights reserved.
//

import UIKit
import Amplitude_iOS

class OnboardingFirstViewController: UIViewController, Storyboarded {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!

    @IBOutlet weak var topLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //here
        titleLabel.text = "Store passwords in your secure Vault"
        subtitleLabel.text = "You only need to remember one master password to access every website you use."
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setGradientBackgroundColor(colors: [UIColor.init(hex: "1461D6"), UIColor.init(hex: "00FFFF")], axis: .horizontal, cornerRadius: 12) { view in
                    guard let continueButton = view as? UIButton, let imageView = continueButton.imageView else { return }
            continueButton.bringSubviewToFront(imageView) // To display imageview of button
        }
        continueButton.addTarget(self, action: #selector(showSecondOnboardingScreen), for: .touchUpInside)
        
        Amplitude.instance()?.logEvent("onboarding_1")
        
        
//        var screenType: ScreenType {
//            guard iPhone else { return .unknown }
//            switch UIScreen.main.nativeBounds.height {
//
//            case 2532:
//                return .iPhone_12_12Pro
//
//            case 2778:
//                return .iPhone_12ProMax
//            default:
//                return .unknown
//            }
//        }
        
        topLabelTopConstraint.constant = 120
        imageBottomConstraint.constant = 124
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("5s")
                topLabelTopConstraint.constant = 40
                imageBottomConstraint.constant = 20
            case 1334:
                print("iPhone 6/6S/7/8/SE2nd")
                topLabelTopConstraint.constant = 80
                imageBottomConstraint.constant = 60
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                imageBottomConstraint.constant = 80
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
//                imageBottomConstraint.constant = 180
            default:
                print("Unknown")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func showSecondOnboardingScreen() {
        VibratorEngine.shared.actionTaptic()
        let vc = OnboardingSecondViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
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
