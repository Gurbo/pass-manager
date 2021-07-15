//
//  AutofillNavigationViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/5/21.
//

import UIKit

class AutofillNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kTitleWhiteColor),
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: kTitleWhiteColor),
                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34.0, weight: .bold)]
            navBarAppearance.backgroundColor = UIColor.init(hex: kCellColor)
            navBarAppearance.shadowColor = .clear
            
            navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.init(hex: kCellColor)), for: .default)
            
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        // Do any additional setup after loading the view.
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
