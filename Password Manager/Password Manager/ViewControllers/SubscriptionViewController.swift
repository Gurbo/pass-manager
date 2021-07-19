//
//  SubscriptionViewController.swift
//  Password Manager
//
//  Created by Alex Gurbo on 7/15/21.
//

import UIKit
import NVActivityIndicatorView
import Purchases
import Amplitude_iOS
import Firebase
import Lottie

class SubscriptionViewController: UIViewController, UIScrollViewDelegate, Storyboarded {

    @IBOutlet weak var allViewsScrollView: UIScrollView!
    @IBOutlet weak var getPremiumTitle: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBOutlet weak var firstProduct: ProductView!
    @IBOutlet weak var secondProduct: ProductView!
    @IBOutlet weak var secondProductDiscountLabel: UILabel!
    @IBOutlet weak var thirdProduct: ProductView!
    @IBOutlet weak var thirdProductDiscountLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var firstPlusLabel: UILabel!
    @IBOutlet weak var secondPlusLabel: UILabel!
    @IBOutlet weak var thirdPlusLabel: UILabel!
    @IBOutlet weak var fourthPlusLabel: UILabel!
    
    @IBOutlet weak var purchaseButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productCellHeight: NSLayoutConstraint!
    @IBOutlet weak var secondProductCellHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdProductCellHeight: NSLayoutConstraint!
    @IBOutlet weak var purchaseButtonTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var animationImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var crossTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var animationView: AnimationView!
    
    var textContentView: TextContentView?
    
    var currentPackage: Purchases.Package?
    var selectedProductIndex: Int?
    
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    
    var weeklyPrice: Float = 0
    var monthlyPrice: Float = 0
    var annualPrice: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
        
        Analytics.logEvent("paywall_app", parameters: nil)
        Amplitude.instance()?.logEvent("paywall_app")
        self.view.backgroundColor = UIColor.init(hex: kBlackBackgroundColor)
        
        
        getPremiumTitle.font = UIFont.systemFont(ofSize: 28.0, weight: .semibold)
        getPremiumTitle.textColor = .white
        getPremiumTitle.text = "Unlock all PRO features. Cancel anytime."
        
        
        purchaseButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        
        purchaseButton.setGradientBackgroundColor(colors: [UIColor.init(hex: "1461D6"), UIColor.init(hex: "00FFFF")], axis: .horizontal, cornerRadius: 12) { view in
                    guard let purchaseButton = view as? UIButton, let imageView = purchaseButton.imageView else { return }
            purchaseButton.bringSubviewToFront(imageView) // To display imageview of button
        }

        
//        firstPlusLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
//        secondPlusLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
//        thirdPlusLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
//        fourthPlusLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)

        self.closeButton.isHidden = true
        
        
        let showExitAfter = RemoteConfigHandler.shared.remoteConfig[show_paywall_exit_after].numberValue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(showExitAfter as! Int)) {
            self.closeButton.isHidden = false
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.shakeButton(button: self.purchaseButton)
        }
        
        addAnimation(to: animationView, name: "lf20_wfqrpe0x")
        
        let appleFontPriorityEnabled = RemoteConfigHandler.shared.remoteConfig[apple_font_priority].boolValue
        if appleFontPriorityEnabled {
            termsLabel.text = "You can cancel your subscription or trial anytime by cancelling your subscription through your ITunes account settings, or it will automatically renew. This must be done 24 hours before the end of the trial or any subscription period to avoid being charged. Subscription with a trial period will automatically renew to a paid subscription. Please note: any unused portion of a trial period (if offered) will be forfeited when you purchase a premium subscription during the trial period. Subscription payments will be charged to your iTunes account at confirmation of your purchase and upon commencement of each renewal team. For mo information, please see our Terms of Use & Privacy Policy."
        } else {
            termsLabel.text = ""
        }
        
        secondProductDiscountLabel.backgroundColor = UIColor.init(hex: "C53AF5")
        secondProductDiscountLabel.textColor = .white
        thirdProductDiscountLabel.backgroundColor = UIColor.init(hex: "C53AF5")
        thirdProductDiscountLabel.textColor = .white
        
        purchaseButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        purchaseButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        purchaseButton.imageView?.transform = CGAffineTransform(scaleX: -3.0, y: 1.0)
        purchaseButton.layer.cornerRadius = 23.0
        
        indicator.type = .lineScalePulseOut
        blackView.isHidden = true
        indicator.startAnimating()
        
        closeButton.addTarget(self, action: #selector(closePaywall), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restorePurchase), for: .touchUpInside)
        purchaseButton.addTarget(self, action: #selector(makePurchase), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(showTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(showPrivacy), for: .touchUpInside)
        
        restoreButton.isHidden = true
        purchaseButton.isHidden = true
        termsButton.isHidden = true
        termsLabel.isHidden = true
        privacyButton.isHidden = true
        firstProduct.isHidden = true
        secondProduct.isHidden = true
        secondProductCellHeight.constant = 0
        secondProductDiscountLabel.isHidden = true
        thirdProduct.isHidden = true
        thirdProductCellHeight.constant = 0
        thirdProductDiscountLabel.isHidden = true
        
        firstProduct.selectButton.tag = 0
        secondProduct.selectButton.tag = 1
        thirdProduct.selectButton.tag = 2
        
        setProducts()
        
        firstProduct.layer.cornerRadius = 12.0
        secondProduct.layer.cornerRadius = 12.0
        secondProductDiscountLabel.layer.masksToBounds = true
        secondProductDiscountLabel.layer.cornerRadius = 5.0
        thirdProduct.layer.cornerRadius = 12.0
        thirdProductDiscountLabel.layer.masksToBounds = true
        thirdProductDiscountLabel.layer.cornerRadius = 5.0

        productCellHeight.constant = 55
        purchaseButtonHeightConstraint.constant = 50
        
        
        animationImageHeightConstraint.constant = 274
        animationImageTopConstraint.constant = 38
        crossTopConstraint.constant = 60
        
        
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                purchaseButton.layer.cornerRadius = 15.0
                firstProduct.layer.cornerRadius = 8.0
                secondProduct.layer.cornerRadius = 8.0
                thirdProduct.layer.cornerRadius = 8.0

                secondProductDiscountLabel.layer.cornerRadius = 3.0
                thirdProductDiscountLabel.layer.cornerRadius = 3.0

                productCellHeight.constant = 40
                purchaseButtonHeightConstraint.constant = 40
                
                
                animationImageHeightConstraint.constant = 120
                animationImageTopConstraint.constant = 0
                crossTopConstraint.constant = 20
                
                
//                contentLayoutBottomConstraint.constant = -250

            case 1334:
                print("iPhone 6/6S/7/8/SE2nd")
                
                
                animationImageHeightConstraint.constant = 200
                animationImageTopConstraint.constant = 0
                crossTopConstraint.constant = 30
                
                
                purchaseButton.layer.cornerRadius = 17.0
                firstProduct.layer.cornerRadius = 10.0
                secondProduct.layer.cornerRadius = 10.0
                thirdProduct.layer.cornerRadius = 10.0

                secondProductDiscountLabel.layer.cornerRadius = 4.0
                thirdProductDiscountLabel.layer.cornerRadius = 4.0

                productCellHeight.constant = 45
                purchaseButtonHeightConstraint.constant = 45
//                productsTopConstraint.constant = -25
//                contentLayoutBottomConstraint.constant = -220
                //done
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                animationImageHeightConstraint.constant = 200
                animationImageTopConstraint.constant = 20
                crossTopConstraint.constant = 30
            case 2436:
                print("iPhone X/XS/11 Pro")
                animationImageHeightConstraint.constant = 200
                animationImageTopConstraint.constant = 30
                crossTopConstraint.constant = 50
            case 2688:
                print("iPhone XS Max/11 Pro Max")
//                contentLayoutBottomConstraint.constant = -50
                //done
            case 1792:
                print("iPhone XR/ 11")
//                contentLayoutBottomConstraint.constant = -50
                //done
            default:
                print("Unknown")
            }
        }
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

    func setProducts() {
        let offeringName = RemoteConfigHandler.shared.remoteConfig[subscription_offering].stringValue
        InAppHandler.shared.getAvaiableProducts(offeringName: offeringName!) { (offering) in
            VibratorEngine.shared.actionTaptic()
            
            self.restoreButton.isHidden = false
            self.purchaseButton.isHidden = false
            self.termsButton.isHidden = false
            self.privacyButton.isHidden = false
            self.privacyButton.isHidden = false
            self.termsLabel.isHidden = false
            
            self.blackView.isHidden = true
            self.indicator.stopAnimating()
            if offering.availablePackages.count == 1 {
                self.purchaseButtonTopConstraint.constant = self.purchaseButtonTopConstraint.constant - 40
            } else if offering.availablePackages.count == 2 {
                self.purchaseButtonTopConstraint.constant = self.purchaseButtonTopConstraint.constant - 20
            }
                for (index, package) in offering.availablePackages.enumerated() {
                    var product: ProductView?
                    if index == 0 {
                        self.firstProduct.isHidden = false
                        self.firstProduct.package = package
                        self.firstProduct.state = .nonactive
                        
                        product = self.firstProduct
                        if index == (offering.availablePackages.count - 1) {
                            self.firstProduct.state = .active
                            self.currentPackage = package
                            self.selectedProductIndex = index
                        }
                    } else if index == 1 {
                        self.secondProduct.isHidden = false
                        self.secondProductCellHeight.constant = self.productCellHeight.constant
                        self.secondProduct.package = package
                        self.secondProduct.state = .nonactive
                        
                        product = self.secondProduct
                        if index == (offering.availablePackages.count - 1) {
                            self.secondProduct.state = .active
                            self.currentPackage = package
                            self.selectedProductIndex = index
                        }
                    } else if index == 2 {
                        self.thirdProduct.isHidden = false
                        self.thirdProductCellHeight.constant = self.productCellHeight.constant
                        self.thirdProduct.package = package
                        self.thirdProduct.state = .nonactive
                        
                        product = self.thirdProduct
                        if index == (offering.availablePackages.count - 1) {
                            self.thirdProduct.state = .active
                            self.currentPackage = package
                            self.selectedProductIndex = index
                        }
                    }
                    var productDurationString = ""
                    switch package.packageType {
                    case .annual:
                        productDurationString = "Unlimited Year  "
                        self.annualPrice = Float(truncating: package.product.price)
                    case .monthly:
                        productDurationString = "Unlimited Month  "
                        self.monthlyPrice = Float(truncating: package.product.price)
                    case .weekly:
                        productDurationString = "Unlimited Week  "
                        self.weeklyPrice = Float(truncating: package.product.price)
                    case .lifetime:
                        productDurationString = "Unlock All Forever  "
                    default:
                        print("")
                    }
                    
                    if let _ = package.product.prettyPrice {
                        let appleFontPriorityEnabled = RemoteConfigHandler.shared.remoteConfig[apple_font_priority].boolValue
                        
                        var firstAttributeFont = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
                        var secondAttributeFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)
                        var trialAttributeFont = UIFont.systemFont(ofSize: 20.0, weight: .bold)
                        var continueFontSize: CGFloat = 20.0

                        if appleFontPriorityEnabled {
                            firstAttributeFont = UIFont.systemFont(ofSize: 15.0, weight: .regular)
                            secondAttributeFont = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
                            trialAttributeFont = UIFont.systemFont(ofSize: 17.0, weight: .medium)
                            continueFontSize = 17.0
                        }
                        
                        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: firstAttributeFont]
                        let secondAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: secondAttributeFont]

                        let continueWithAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: continueFontSize, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white]
                        
                        let continueString = NSMutableAttributedString(string: "Continue   ", attributes: continueWithAttributes)
                        self.purchaseButton.setAttributedTitle(continueString, for: .normal)
                        
                        switch package.packageType {
                        case .lifetime:
                            self.purchaseButton.setAttributedTitle(continueString, for: .normal)
                        default:
                            print("")
                        }
                        
                        if appleFontPriorityEnabled {
                            let trialWithAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: trialAttributeFont, NSAttributedString.Key.foregroundColor: UIColor.white]
                            let firstString = NSMutableAttributedString(string: "Subscribe   ", attributes: trialWithAttributes)
                            self.purchaseButton.setAttributedTitle(firstString, for: .normal)
                        }
                        
                        var trialString: String = ""
                        if let introPrice = package.product.introductoryPrice {
                            switch introPrice.subscriptionPeriod.unit {
                            case .day:
                                trialString = "\(introPrice.subscriptionPeriod.numberOfUnits) trial days"
                            case .week:
                                trialString = "\(introPrice.subscriptionPeriod.numberOfUnits) trial week"
                            default:
                                print("")
                            }
                            
                            let trialWithAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: trialAttributeFont, NSAttributedString.Key.foregroundColor: UIColor.white]

                            let firstString = NSMutableAttributedString(string: "Continue with ", attributes: continueWithAttributes)
                            let secondString = NSMutableAttributedString(string: "\(trialString)  ", attributes: trialWithAttributes)

                            let thirdAttrString = NSMutableAttributedString.init()
                            thirdAttrString.append(firstString)
                            thirdAttrString.append(secondString)

                            self.purchaseButton.setAttributedTitle(thirdAttrString, for: .normal)
                            
                            if appleFontPriorityEnabled {
                                let trialWithAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: trialAttributeFont, NSAttributedString.Key.foregroundColor: UIColor.white]
                                let firstString = NSMutableAttributedString(string: "Subscribe   ", attributes: trialWithAttributes)
                                self.purchaseButton.setAttributedTitle(firstString, for: .normal)
                            }
                        }
                        
                        let firstString = NSMutableAttributedString(string: productDurationString, attributes: firstAttributes)
                        let showMonthlyPrices = RemoteConfigHandler.shared.remoteConfig[showMonthlyDividedPrices].boolValue
                        
                        var priceString = ""
                        switch package.packageType {
                        case .annual:
                            if showMonthlyPrices {
                                var priceDividedInto12 = package.product.price as Decimal / 12
                                var roundedPrice = Decimal()
                                NSDecimalRound(&roundedPrice, &priceDividedInto12, 2, .bankers)
                                if let currency = package.product.prettyCurrency {
                                    priceString = "\(roundedPrice) \(currency) per month bill annualy"
                                }
                            } else {
                                if let pricePretty = package.product.prettyPrice {
                                    priceString = "\(pricePretty)  \(trialString)"
                                }
                            }
                        case .monthly:
                            if showMonthlyPrices {
                                if let currency = package.product.prettyCurrency {
                                    priceString = "\(package.product.price) \(currency) per month"
                                }
                            } else {
                                if let pricePretty = package.product.prettyPrice {
                                    priceString = "\(pricePretty) \(trialString)"
                                }
                            }

                        case .weekly:
                            if showMonthlyPrices {
                                var priceMultipliedInto4 = package.product.price as Decimal * 4
                                var roundedPrice = Decimal()
                                NSDecimalRound(&roundedPrice, &priceMultipliedInto4, 2, .bankers)
                                if let currency = package.product.prettyCurrency {
                                    priceString = "\(roundedPrice) \(currency) per month bill weekly"
                                }
                            } else {
                                if let pricePretty = package.product.prettyPrice {
                                    priceString = "\(pricePretty) \(trialString)"
                                }
                            }
                        case .lifetime:
                            
                            if let pricePretty = package.product.prettyPrice {
                                priceString = "\(pricePretty) \(trialString)"
                            }
//                            if let currency = package.product.prettyCurrency {
//                                priceString = "\(package.product.price) \(currency)"
//                            }
                        default:
                            print("")
                        }
                        
                        let secondString = NSMutableAttributedString(string: priceString, attributes: secondAttributes)
                        
                        product?.nameLabel.attributedText = firstString
                        product?.priceLabel.attributedText = secondString
                    }
                }
        self.calculateDiscounts()
        }
    }
    
    func shakeButton(button: UIButton) {
        button.layer.removeAllAnimations()
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.02
        shake.repeatCount = 3
        shake.autoreverses = true
        shake.isRemovedOnCompletion = false
        
        let fromPoint = CGPoint(x: button.center.x - 6, y: button.center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: button.center.x + 6, y: button.center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        button.layer.add(shake, forKey: "position")
    }

    
    @IBAction func changeProduct(_ sender: UIButton) {
        VibratorEngine.shared.actionTaptic()
        if sender.tag != selectedProductIndex {
            self.selectedProductIndex = sender.tag
            if sender.tag == 0 {
                self.firstProduct.state = .active
                self.secondProduct.state = .nonactive
                self.thirdProduct.state = .nonactive
                self.currentPackage = self.firstProduct.package
            } else if sender.tag == 1 {
                self.firstProduct.state = .nonactive
                self.secondProduct.state = .active
                self.thirdProduct.state = .nonactive
                self.currentPackage = self.secondProduct.package
            } else if sender.tag == 2 {
                self.firstProduct.state = .nonactive
                self.secondProduct.state = .nonactive
                self.thirdProduct.state = .active
                self.currentPackage = self.thirdProduct.package
            }
            
            var trialAttributeFont = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            var continueFontSize: CGFloat = 20.0
            
            let appleFontPriorityEnabled = RemoteConfigHandler.shared.remoteConfig[apple_font_priority].boolValue
            
            if appleFontPriorityEnabled {
                trialAttributeFont = UIFont.systemFont(ofSize: 17.0, weight: .medium)
                continueFontSize = 17.0
            }
            
            let continueWithAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: continueFontSize, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white]
            let continueString = NSMutableAttributedString(string: "Continue   ", attributes: continueWithAttributes)
            self.purchaseButton.setAttributedTitle(continueString, for: .normal)
            
            if let introPrice =  self.currentPackage?.product.introductoryPrice {
                var trialString = ""
                    switch introPrice.subscriptionPeriod.unit {
                    case .day:
                        trialString = "\(introPrice.subscriptionPeriod.numberOfUnits) trial days"
                    case .week:
                        trialString = "\(introPrice.subscriptionPeriod.numberOfUnits) trial week"
                    default:
                        print("")
                    }
                
                let trialWithAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: trialAttributeFont, NSAttributedString.Key.foregroundColor: UIColor.white]

                let firstString = NSMutableAttributedString(string: "Continue with ", attributes: continueWithAttributes)
                let secondString = NSMutableAttributedString(string: "\(trialString)  ", attributes: trialWithAttributes)

                let thirdAttrString = NSMutableAttributedString.init()
                thirdAttrString.append(firstString)
                thirdAttrString.append(secondString)

                self.purchaseButton.setAttributedTitle(thirdAttrString, for: .normal)
            }
            
            if appleFontPriorityEnabled {
                let trialWithAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: trialAttributeFont, NSAttributedString.Key.foregroundColor: UIColor.white]
                let firstString = NSMutableAttributedString(string: "Subscribe   ", attributes: trialWithAttributes)
                self.purchaseButton.setAttributedTitle(firstString, for: .normal)
            }

        }
    }
    
    func calculateDiscounts() {
        if (weeklyPrice > 0 && monthlyPrice > 0 && annualPrice > 0) {
            let monthlyDiscount = (((weeklyPrice * 4) - monthlyPrice) / (weeklyPrice * 4)) * 100
            self.secondProductDiscountLabel.isHidden = false
            self.secondProductDiscountLabel.text = "Save \(Int(monthlyDiscount.rounded()))%"
            
            let yearlyDiscount = (((weeklyPrice * 52) - annualPrice) / (weeklyPrice * 52)) * 100
            self.thirdProductDiscountLabel.isHidden = false
            self.thirdProductDiscountLabel.text = "Save \(Int(yearlyDiscount.rounded()))%"
        } else if (weeklyPrice > 0 && monthlyPrice > 0) {
            let discount = (((weeklyPrice * 4) - monthlyPrice) / (weeklyPrice * 4)) * 100
            self.secondProductDiscountLabel.isHidden = false
            self.secondProductDiscountLabel.text = "Save \(Int(discount.rounded()))%"
        } else if (weeklyPrice > 0 && annualPrice > 0) {
            let discount = (((weeklyPrice * 52) - annualPrice) / (weeklyPrice * 52)) * 100
            self.secondProductDiscountLabel.isHidden = false
            self.secondProductDiscountLabel.text = "Save \(Int(discount.rounded()))%"
        }  else if (monthlyPrice > 0 && annualPrice > 0) {
            let discount = (((monthlyPrice * 12) - annualPrice) / (monthlyPrice * 12)) * 100
            self.secondProductDiscountLabel.isHidden = false
            self.secondProductDiscountLabel.text = "Save \(Int(discount.rounded()))%"
        }
    }
    
    @objc func closePaywall() {
        VibratorEngine.shared.actionTaptic()
        Amplitude.instance()?.logEvent("paywall_app_close")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showTerms() {
        VibratorEngine.shared.actionTaptic()
        textContentView = Bundle.main.loadNibNamed("TextContentView", owner: self, options: nil)?.first as? TextContentView
        textContentView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        textContentView?.closeButton.addTarget(self, action: #selector(closeTextContentView), for: .touchUpInside)
        textContentView?.contentView.text = load(file: "terms")
        textContentView?.contentView.backgroundColor = .white
        if let textContentView = self.textContentView {
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
              self.view.addSubview(textContentView)
            }, completion: nil)
        }
    }

    @objc func showPrivacy() {
        VibratorEngine.shared.actionTaptic()
        textContentView = Bundle.main.loadNibNamed("TextContentView", owner: self, options: nil)?.first as? TextContentView
        textContentView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        textContentView?.closeButton.addTarget(self, action: #selector(closeTextContentView), for: .touchUpInside)
        textContentView?.contentView.backgroundColor = .white
        textContentView?.contentView.text = load(file: "privacy")
        if let textContentView = self.textContentView {
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
              self.view.addSubview(textContentView)
            }, completion: nil)
        }
    }
    
    @objc func closeTextContentView() {
        VibratorEngine.shared.actionTaptic()
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.textContentView?.removeFromSuperview()
        }) { (true) in
        }
    }
    
    func load(file name:String) -> String {
        if let path = Bundle.main.path(forResource: name, ofType: "txt") {
            if let contents = try? String(contentsOfFile: path) {
                return contents
            } else {
                print("Error! - This file doesn't contain any text.")
            }
        } else {
            print("Error! - This file doesn't exist.")
        }
        return ""
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
                
                Amplitude.instance()?.logEvent("paywall.purchase.pressed", withEventProperties: eventProperties)
                Analytics.logEvent("paywall_purchase_pressed", parameters: eventProperties)
                
                Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                  self.indicator.stopAnimating()
                    self.blackView.isHidden = true
                    if let error = error {
                        if !userCancelled {
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            Amplitude.instance()?.logEvent("paywall.purchase.cancel", withEventProperties: eventProperties)
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
                                
                                Amplitude.instance()?.logEvent("paywall.purchase.success", withEventProperties: eventProperties)
                                Analytics.logEvent("paywall_purchase_success", parameters: eventProperties)
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
    
    @objc func restorePurchase() {
        Amplitude.instance()?.logEvent("paywall.restore")
        
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
}
