//
//  OnboardingSecondViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/9/21.
//

import UIKit
import Amplitude_iOS

class OnboardingSecondViewController: UIViewController, Storyboarded {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    

    @IBOutlet weak var topLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //here
        titleLabel.text = "Forget about typing your passwords"
        subtitleLabel.text = "We'll help you log in automatically whenever you want, securely."
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setGradientBackgroundColor(colors: [UIColor.init(hex: "1461D6"), UIColor.init(hex: "00FFFF")], axis: .horizontal, cornerRadius: 12) { view in
                    guard let continueButton = view as? UIButton, let imageView = continueButton.imageView else { return }
            continueButton.bringSubviewToFront(imageView) // To display imageview of button
        }
        continueButton.addTarget(self, action: #selector(showThirdOnboardingScreen), for: .touchUpInside)
        
        Amplitude.instance()?.logEvent("onboarding_2")
        
        
//        var screenType: ScreenType {
//            guard iPhone else { return .unknown }
//            switch UIScreen.main.nativeBounds.height {

//            case 2532:
//                return .iPhone_12_12Pro

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
                imageBottomConstraint.constant = 100
            case 2688:
                print("iPhone XS Max/11 Pro Max")
            case 1792:
                print("iPhone XR/ 11")
            case 2532:
                print("iPhone_12_12Pro")
            case 2778:
                print("iPhone_12ProMax")
                imageBottomConstraint.constant = 160
            default:
                print("Unknown")
            }
        } else {
            //ipad
            switch UIScreen.main.nativeBounds.height {
            case 2732:
                print("IS_IPAD_PRO_12_9")
                imageBottomConstraint.constant = 400
            case 2388:
                print("IS_IPAD_PRO_11")
                imageBottomConstraint.constant = 310
            case 2360:
                print("IS_IPAD_AIR_4")
                imageBottomConstraint.constant = 300
            case 2224:
                print("IS_IPAD_PRO_10_5")
                imageBottomConstraint.constant = 290
            case 2160:
                print("IS_IPAD_8th")
                imageBottomConstraint.constant = 280
            case 2048:
                print("IS_IPAD_OR_MINI")
                imageBottomConstraint.constant = 250
            default:
                print("Unknown")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func showThirdOnboardingScreen() {
        VibratorEngine.shared.actionTaptic()
        let vc = OnboardingThirdViewController.instantiate()
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
