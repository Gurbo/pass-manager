//
//  VaultNavigationViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/2/21.
//

import UIKit

class VaultNavigationViewController: UINavigationController {

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
                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34.0, weight: .bold)]
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

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage.init() }
        UIGraphicsEndImageContext()

        return image
    }
}
