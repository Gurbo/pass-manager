//
//  CustomTabbarViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/2/21.
//

import UIKit

class CustomTabbarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.tabBar.tintColor = UIColor.init(hex: "388BF1") // tab bar icon tint color
        self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.white // tab
        
        self.tabBar.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController.title == "MapNavigationController" {
//            if UserData.isUserSubscribed {
//                return true
//            } else {
//                let vc = SubscriptionViewController.instantiate()
//                self.present(vc, animated: true, completion: nil)
//                return false
//            }
//        } else {
//            return true
//        }
//    }
}
