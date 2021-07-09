//
//  OnboardingPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Alex Gurbo on 2/14/21.
//  Copyright © 2021 AG. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Purchases
import Amplitude_iOS
import Firebase

class OnboardingPaywallViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var crossTopConstraint: NSLayoutConstraint!
    
    var weeklyPrice: Float = 0
    var monthlyPrice: Float = 0
    var annualPrice: Float = 0
    
    weak var coordinator: MainCoordinator?
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var premiumAccessLabel: UILabel!
    @IBOutlet weak var showMapLabel: UILabel!
    @IBOutlet weak var unlimitedScanningLabel: UILabel!
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var appleSupportLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var currentPackage: Purchases.Package?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prcSize = RemoteConfigHandler.shared.remoteConfig[onbPaywlSize].numberValue
        
        priceLabel.font = UIFont.systemFont(ofSize: prcSize as! CGFloat, weight: .medium)
        //here
        restoreButton.setTitle("Restore", for: .normal)
        premiumAccessLabel.text = "Get Premium Access"
        showMapLabel.text = "Find On The Map"
        unlimitedScanningLabel.text = "Unlimited Scanning"
        noAdsLabel.text = "No Ads"
        appleSupportLabel.text = "1000+ Devices Support"
        purchaseButton.setTitle("CONTINUE", for: .normal)
        //priceLabel
        
        Analytics.logEvent("paywall_onboarding", parameters: nil)
        Amplitude.instance()?.logEvent("paywall_onboarding")
        
        crossTopConstraint.constant = 64
        topLabelTopConstraint.constant = 130
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("5s")
            topLabelTopConstraint.constant = 25
            crossTopConstraint.constant = 20
        case 1334:
            print("iPhone 6/6S/7/8/SE2nd")
            topLabelTopConstraint.constant = 80
            crossTopConstraint.constant = 30
        case 1920, 2208:
            print("iPhone 6+/6S+/7+/8+")
            topLabelTopConstraint.constant = 130
            case 2436:
                print("iPhone X/XS/11 Pro")

            case 2688:
                print("iPhone XS Max/11 Pro Max")

            case 1792:
                print("iPhone XR/ 11")

            default:
                print("Unknown")
            }
        }
        
        purchaseButton.layer.cornerRadius = 12.0
        self.closeButton.isHidden = true
        let showExitAfter = RemoteConfigHandler.shared.remoteConfig[show_paywall_exit_after].numberValue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(showExitAfter as! Int)) {
            self.closeButton.isHidden = false
        }
        
        indicator.type = .lineScalePulseOut
        indicator.color = .white
        blackView.isHidden = false
        indicator.startAnimating()
        
        closeButton.addTarget(self, action: #selector(closePaywall), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restorePurchase), for: .touchUpInside)
        purchaseButton.addTarget(self, action: #selector(makePurchase), for: .touchUpInside)
        
        setProducts()
    }
    
    func setProducts() {
        let offeringName = RemoteConfigHandler.shared.remoteConfig[onboarding_offering].stringValue
        InAppHandler.shared.getAvaiableProducts(offeringName: offeringName!) { (offering) in
            VibratorEngine.shared.actionTaptic()
            
            self.restoreButton.isHidden = false
            self.purchaseButton.isHidden = false

            
            self.blackView.isHidden = true
            self.indicator.stopAnimating()
            
            if let package = offering.availablePackages.first {
                self.currentPackage = package
                
                var priceString = ""
                
                var productDurationString = ""
                switch package.packageType {
                case .annual:
                    productDurationString = "Unlimited Yearly VIP for "
                    priceString = "\(productDurationString)"
                    self.annualPrice = Float(truncating: package.product.price)
                case .monthly:
                    productDurationString = "Unlimited Month for "
                    priceString = "\(productDurationString)"
                    self.monthlyPrice = Float(truncating: package.product.price)
                case .weekly:
                    productDurationString = "Unlimited Week for "
                    priceString = "\(productDurationString)"
                    self.weeklyPrice = Float(truncating: package.product.price)
                case .lifetime:
                    productDurationString = "Unlock All Forever for "
                    priceString = "\(productDurationString)"
                default:
                    print("")
                    
                }
                
                if let prettyPrice = package.product.prettyPrice {
                    priceString = "\(priceString)\(prettyPrice) "
                    var trialString: String = ""
                    if let introPrice = package.product.introductoryPrice {
                        switch introPrice.subscriptionPeriod.unit {
                        case .day:
                            trialString = "\(introPrice.subscriptionPeriod.numberOfUnits) trial days"
                            priceString = "\(priceString)/ \(trialString)"
                        case .week:
                            trialString = "\(introPrice.subscriptionPeriod.numberOfUnits) trial week"
                            priceString = "\(priceString)/ \(trialString)"
                        default:
                            print("")
                        }

                    }
                }
                self.priceLabel.text = priceString

            } else {
                //NO PACKAGES
            }

        }
    }
    
    @objc func closePaywall() {
        VibratorEngine.shared.actionTaptic()
        UserData.isFirstLaunch = false
        Amplitude.instance()?.logEvent("paywall_onboarding_close")
        self.coordinator?.showOnboardingOrMainScreen()
    }
    
    @objc func restorePurchase() {
        Amplitude.instance()?.logEvent("onboarding.paywall.restore")
        
        VibratorEngine.shared.actionTaptic()
        self.blackView.isHidden = false
        self.indicator.startAnimating()
        Purchases.shared.restoreTransactions { (info, error) in
            self.indicator.stopAnimating()
            self.blackView.isHidden = true
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                if let purchaserInfo = info {
                     if purchaserInfo.entitlements[proEntitlementName]?.isActive == true {
                        InAppHandler.shared.isUserSubscribed = true
                        UserData.isUserSubscribed = true
                        UserData.shouldShowRater = true
                        
                        let identify = AMPIdentify.init()
                        identify.set("subscribed", value: "true" as NSObject)
                        Amplitude.instance()?.identify(identify)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIAfterPurchase"), object: nil)
                        self.closePaywall()
                    }
                    else {
                        let alert = UIAlertController(title: "Restore Unsuccessful", message: "No prior purchases found for your account.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func makePurchase() {
        VibratorEngine.shared.actionTaptic()
        
        if Purchases.canMakePayments() {
            if let package = self.currentPackage {
                self.blackView.isHidden = false
                self.indicator.startAnimating()
                
                var eventProperties: [String: Any]?
                
                var inappType = ""
                let subscriptionAmount = package.product.prettyPrice
                var trialDelay = ""
                
                switch package.packageType {
                case .annual:
                    inappType = "Annual"
                case .monthly:
                    inappType = "Monthly"
                case .weekly:
                    inappType = "Weekly"
                case .lifetime:
                    inappType = "Lifetime"
                default:
                    print("")
                }
                
                if let introPrice = package.product.introductoryPrice {
                    switch introPrice.subscriptionPeriod.unit {
                    case .day:
                        trialDelay = "\(introPrice.subscriptionPeriod.numberOfUnits)"
                    default:
                        print("")
                    }
                }
                
                if trialDelay.count > 0 {
                    eventProperties = ["type" : inappType,
                                       "subscriptionPrice" : subscriptionAmount ?? "",
                                       "trialDelay" : trialDelay]
                } else {
                    eventProperties = ["type" : inappType,
                                       "subscriptionPrice" : subscriptionAmount ?? ""]
                }
                
                Amplitude.instance()?.logEvent("onboarding.paywall.purchase.pressed", withEventProperties: eventProperties)
                Analytics.logEvent("onboarding_paywall_purchase_pressed", parameters: eventProperties)
                
                Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                  self.indicator.stopAnimating()
                    self.blackView.isHidden = true
                    if let error = error {
                        if !userCancelled {
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            Amplitude.instance()?.logEvent("onboarding.paywall.purchase.cancel", withEventProperties: eventProperties)
                        }
                    } else {
                        if let subsInfo = purchaserInfo {
                            if (subsInfo.activeSubscriptions.count > 0 || !subsInfo.nonConsumablePurchases.isEmpty) {
                                InAppHandler.shared.isUserSubscribed = true
                                UserData.isUserSubscribed = true
                                UserData.shouldShowRater = true
                              
                                
                                let identify = AMPIdentify.init()
                                identify.set("subscribed", value: "true" as NSObject)
                                Amplitude.instance()?.identify(identify)
                                
                                Amplitude.instance()?.logEvent("onboarding.paywall.purchase.success", withEventProperties: eventProperties)
                                Analytics.logEvent("onboarding_paywall_purchase_success", parameters: eventProperties)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIAfterPurchase"), object: nil)
                                self.closePaywall()
                            }
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please set up your ITunes Account correctly & Check that in-app purchases are allowed in Settings->Screen Time->Content & Privacy Restrictions", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
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
