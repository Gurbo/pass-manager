//
//  LoadingViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/8/21.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import FirebaseInstallations
import Amplitude_iOS

class LoadingViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var internetLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = UIColor.init(hex: "00FFFF")
        activityIndicator.type = .ballClipRotate
        activityIndicator.startAnimating()
        self.navigationController?.navigationBar.isHidden = true
        
        Amplitude.instance()?.logEvent("loading_screen")
        
        titleLabel.text = ""
        internetLabel.text = "Turn on the Internet to use the app"
        
        UIView.animate (withDuration: 2.0, delay: 0.0, options: [.curveEaseIn], animations: {
            self.titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        }, completion: nil)
        
        internetLabel.isHidden = true
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection is Available!")
        } else {
            internetLabel.isHidden = false
        }
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        RemoteConfigHandler.shared.setupRemoteConfig()
        RemoteConfigHandler.shared.fetchAndActivateRemoteConfig { (status) in
            
            InAppHandler.shared.checkUserSubscription { (isSubscribed) in

            }
            
            DispatchQueue.main.async {
                self.coordinator?.showOnboardingOrMainScreen()
            }
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
