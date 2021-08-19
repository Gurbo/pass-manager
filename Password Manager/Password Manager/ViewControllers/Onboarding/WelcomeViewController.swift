//
//  WelcomeViewController.swift
//  BluetoothScanner
//
//  Created by Alex Gurbo on 5/22/21.
//  Copyright © 2021 AG, LLC. All rights reserved.
//

import UIKit
import Lottie
import Amplitude_iOS

class WelcomeViewController: UIViewController, Storyboarded {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var animationView: AnimationView!

    @IBOutlet weak var topLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var appName = "iPassword"
        if let strongName = Bundle.main.displayName {
            appName = strongName
        }
        
        titleLabel.text = "Welcome to\n \(appName)"
        subtitleLabel.text = "The app that makes Internet easier."
        
        continueButton.setTitle("Continue", for: .normal)
        
        addAnimation(to: animationView, name: "lf20_rpr0qbbn")
        
        
        Amplitude.instance()?.logEvent("screen_welcome")
        
        
        continueButton.setGradientBackgroundColor(colors: [UIColor.init(hex: "1461D6"), UIColor.init(hex: "00FFFF")], axis: .horizontal, cornerRadius: 12) { view in
                    guard let continueButton = view as? UIButton, let imageView = continueButton.imageView else { return }
            continueButton.bringSubviewToFront(imageView) // To display imageview of button
        }
        continueButton.addTarget(self, action: #selector(showFirstOnboardingScreen), for: .touchUpInside)
        
        
        topLabelTopConstraint.constant = 120
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("5s")
                topLabelTopConstraint.constant = 40
            case 1334:
                print("iPhone 6/6S/7/8/SE2nd")
                topLabelTopConstraint.constant = 80
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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    private func addAnimation(to view: AnimationView, name: String) {
        let animation = Animation.named(name)
        view.animation = animation
        view.loopMode = .loop
        view.contentMode = .scaleAspectFill
    }
    
    @objc func showFirstOnboardingScreen() {
        VibratorEngine.shared.actionTaptic()
        
        
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "SwitchPaywallViewController") as SwitchPaywallViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
//        let vc = OnboardingFirstViewController.instantiate()
//        navigationController?.pushViewController(vc, animated: true)
    }
}
