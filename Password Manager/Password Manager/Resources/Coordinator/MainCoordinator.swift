//
//  MainCoordinator.swift
//  vibro
//
//  Created by Alex Gurbo on 9/16/20.
//  Copyright © 2020 Alex Gurbo. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = LoadingViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

//    func showSettings() {
//        let vc = SettingsTableViewController.instantiate()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
//    }
//
//    func showOnboardingPaywallScreen() {
//        let vc = OnboardingPaywallViewController.instantiate()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
//    }
//
    func showOnboardingFirstScreen() {
//        let vc = OnboardingFirstViewController.instantiate()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
    }
//
//    func showOnboardingSecondScreen() {
//        let vc = OnboardingSecondViewController.instantiate()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
//    }
//
//    func showOnboardingThirdScreen() {
//        let vc = OnboardingThirdViewController.instantiate()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
//    }
    
    func showOnboardingOrMainScreen() {
        if UserData.isFirstLaunch {
            print("SHOW ONBOARDING")
            let vc = WelcomeViewController.instantiate()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        } else {
//            print("SHOW MAIN SCREEN")
//            let vc = CustomTabbarViewController.instantiate()
//            vc.coordinator = self
//
//            if let window = UIApplication.shared.currentWindow {
//                UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
//                    window.rootViewController = vc
//                }, completion: nil)
//            }
        }
    }
}
