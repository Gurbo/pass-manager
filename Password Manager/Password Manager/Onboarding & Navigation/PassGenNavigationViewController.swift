//
//  PassGenNavigationViewController.swift
//  Password Manager
//
//  Created by Alex on 21.08.21.
//

import UIKit

class PassGenNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .red
//        navigationController?.navigationBar.barTintColor = UIColor.green
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kTitleWhiteColor),
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kTitleWhiteColor),
                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30.0, weight: .bold)]
            navBarAppearance.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
            navBarAppearance.shadowColor = .clear
            
            navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.init(hex: kBlackBackgroundColor)), for: .default)
            
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
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
