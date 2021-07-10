//
//  OnboardingFourthViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/9/21.
//

import UIKit
import Amplitude_iOS

class OnboardingFourthViewController: UIViewController, Storyboarded {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
//    @IBOutlet weak var topLabelTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //here
        titleLabel.text = "We don’t want your data"
        subtitleLabel.text = "All your data is saved locally on your device and you can sync it using any of the supported cloud accounts."
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setGradientBackgroundColor(colors: [UIColor.init(hex: "1461D6"), UIColor.init(hex: "00FFFF")], axis: .horizontal, cornerRadius: 12) { view in
                    guard let continueButton = view as? UIButton, let imageView = continueButton.imageView else { return }
            continueButton.bringSubviewToFront(imageView) // To display imageview of button
        }
        continueButton.addTarget(self, action: #selector(showOnboardingPaywall), for: .touchUpInside)
        
        Amplitude.instance()?.logEvent("onboarding_3")
        
        
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
        
//        topLabelTopConstraint.constant = 130
//        imageBottomConstraint.constant = 125
//        if UIDevice().userInterfaceIdiom == .phone {
//        switch UIScreen.main.nativeBounds.height {
//            case 1136:
//                print("5s")
//                topLabelTopConstraint.constant = 25
//                imageBottomConstraint.constant = 30
//            case 1334:
//                print("iPhone 6/6S/7/8/SE2nd")
//                topLabelTopConstraint.constant = 80
//                imageBottomConstraint.constant = 50
//            case 1920, 2208:
//                print("iPhone 6+/6S+/7+/8+")
//                topLabelTopConstraint.constant = 130
//                imageBottomConstraint.constant = 70
//            case 2436:
//                print("iPhone X/XS/11 Pro")
//            case 2688:
//                print("iPhone XS Max/11 Pro Max")
//            case 1792:
//                print("iPhone XR/ 11")
//            case 2532:
//                print("iPhone_12_12Pro")
//            case 2778:
//                print("iPhone_12ProMax")
//                imageBottomConstraint.constant = 180
//            default:
//                print("Unknown")
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    @objc func showOnboardingPaywall() {
        let showPaywall = RemoteConfigHandler.shared.remoteConfig[show_onboarding_paywall].boolValue
        let paidModeEnabled = RemoteConfigHandler.shared.remoteConfig[paid_mode_enabled].boolValue
        if showPaywall && paidModeEnabled && !UserData.isUserSubscribed {
            let vc = OnboardingPaywallViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if UserData.isFirstLaunch {
                let vc = WelcomeViewController.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = CustomTabbarViewController.instantiate()
                if let window = UIApplication.shared.currentWindow {
                    UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
                        window.rootViewController = vc
                    }, completion: nil)
                }
            }
        }
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
