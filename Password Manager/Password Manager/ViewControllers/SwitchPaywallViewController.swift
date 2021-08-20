//
//  SwitchPaywallViewController.swift
//  Password Manager
//
//  Created by Alex on 19.08.21.
//

import UIKit
import NVActivityIndicatorView
import Purchases
import Amplitude_iOS
import Firebase

class SwitchPaywallViewController: UIViewController, UIScrollViewDelegate, Storyboarded {

    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var imagesContainerView: UIView!
    @IBOutlet weak var imagesScrollView: UIScrollView! {
        didSet{
            imagesScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var reviewsContainerView: UIView!
    @IBOutlet weak var reviewsScrollView: UIScrollView! {
        didSet{
            reviewsScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    
    @IBOutlet weak var switcherContainerView: UIView!
    @IBOutlet weak var switcherLabel: UILabel!
    @IBOutlet weak var switcherTrial: UISwitch!
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var tosButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var leftViewTextLabel: UILabel!
    @IBOutlet weak var centerViewTextLabel: UILabel!
    @IBOutlet weak var rightViewTextLabel: UILabel!

    var textContentView: TextContentView?
    @IBOutlet weak var blackView: UIView!
    
    var reviews: [ReviewView] = []
    var scrollTimer: Timer?

    let images = ["happy_1","happy_2","happy_3"]
    var scrollImageTimer: Timer!
    
    var currentPackage: Purchases.Package?
    var trialPackage: Purchases.Package?
    var nonTrialPackage: Purchases.Package?
    
    
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    @IBOutlet weak var priceLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchViewTopConstraint: NSLayoutConstraint!
    
    
    var weeklyPrice: Float = 0
    var monthlyPrice: Float = 0
    var annualPrice: Float = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserData.paywallWasShown = true
        
        getProducts()
        
        reviews = createReviews()
        
        setSmallViews()
        
        switcherContainerView.backgroundColor = .white
        switcherContainerView.layer.cornerRadius = 15.0
        
        switcherTrial.isOn = false
        switcherLabel.text = "Not sure yet? \nEnable free trial" // Free Trial Enabled
        
        pageControl.numberOfPages = reviews.count
        pageControl.currentPage = 0
        
        
        tosButton.addTarget(self, action: #selector(showTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(showPrivacy), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closePaywall), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restorePurchase), for: .touchUpInside)
        purchaseButton.addTarget(self, action: #selector(makePurchase), for: .touchUpInside)
        
        
        
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            var reviewOffset: CGFloat = 0
            var imageOffset: CGFloat = 0
            if self.pageControl.currentPage == 0 {
                reviewOffset = self.reviewsScrollView.contentSize.width/3
                imageOffset = self.imagesScrollView.contentSize.width/3
            } else if self.pageControl.currentPage == 1 {
                reviewOffset = self.reviewsScrollView.contentSize.width/3 * 2
                imageOffset = self.imagesScrollView.contentSize.width/3 * 2
            } else if self.pageControl.currentPage == 2 {
                reviewOffset = 0
                imageOffset = 0
            }
            self.reviewsScrollView.setContentOffset(CGPoint(x: reviewOffset, y: 0), animated: true)
            self.imagesScrollView.setContentOffset(CGPoint(x: imageOffset, y: 0), animated: true)
        }
        
        imagesScrollView.layer.cornerRadius = 20.0
        
        purchaseButton.setGradientBackgroundColor(colors: [UIColor.init(hex: "1461D6"), UIColor.init(hex: "00FFFF")], axis: .horizontal, cornerRadius: 12) { view in
                    guard let continueButton = view as? UIButton, let imageView = continueButton.imageView else { return }
            continueButton.bringSubviewToFront(imageView) // To display imageview of button
        }
        purchaseButton.setTitle("Continue", for: .normal)
        
        priceLabelTopConstraint.constant = 80
        switchViewTopConstraint.constant = 17
        
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("5s") //DONE
                priceLabelTopConstraint.constant = 0
                switchViewTopConstraint.constant = 7
                
                leftViewTextLabel.font = UIFont.systemFont(ofSize: 11)
                centerViewTextLabel.font = UIFont.systemFont(ofSize: 11)
                rightViewTextLabel.font = UIFont.systemFont(ofSize: 11)
            case 1334:
                print("iPhone 6/6S/7/8/SE2nd") //DONE
                priceLabelTopConstraint.constant = 20
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                priceLabelTopConstraint.constant = 40 //DONE
            case 2436:
                print("iPhone X/XS/11 Pro") //DONE
            case 2688:
                print("iPhone XS Max/11 Pro Max") //DONE
            case 1792:
                print("iPhone XR/ 11") //DONE
            case 2340: //2436
                print("iPhone 12 Mini") //DONE
            case 2532:
                print("iPhone 12 / 12 Pro") //DONE
            case 2778:
                print("iPhone 12 Pro Max") //DONE
            default:
                print("Unknown")
            }
        }
    }
    
    @IBAction func switchWasChanged(_ sender: Any) {
        if let ssender = sender as? UISwitch {
            if ssender.isOn {
                switcherLabel.text = "Free Trial Enabled"
                self.currentPackage = trialPackage
                setupProductsUI(forNonTrialPackage: false)
            } else {
                switcherLabel.text = "Not sure yet? \nEnable free trial"
                self.currentPackage = nonTrialPackage
                setupProductsUI(forNonTrialPackage: true)
            }
        }
    }
    
    func getProducts() {
        
        indicator.type = .lineScalePulseOut
        blackView.isHidden = false
        indicator.startAnimating()
        
        let offeringName = RemoteConfigHandler.shared.remoteConfig[trialOnboardingOffering].stringValue
        InAppHandler.shared.getAvaiableProducts(offeringName: offeringName!) { (offering) in
            VibratorEngine.shared.actionTaptic()
            
            self.restoreButton.isHidden = false
            self.purchaseButton.isHidden = false
            self.tosButton.isHidden = false
            self.privacyButton.isHidden = false
            
            self.blackView.isHidden = true
            self.indicator.stopAnimating()
        
            for (_, package) in offering.availablePackages.enumerated() {
                if let _ = package.product.introductoryPrice {
                    self.trialPackage = package
                } else {
                    self.currentPackage = package
                    self.nonTrialPackage = package
                }
            }
            self.setupProductsUI(forNonTrialPackage: true)
        }
    }
    
    func setupProductsUI(forNonTrialPackage: Bool) {
        if forNonTrialPackage {
            if let nonTrialPCKG = nonTrialPackage {
                var productDurationString = ""
                switch nonTrialPCKG.packageType {
                case .annual:
                    productDurationString = "/year"
                    self.annualPrice = Float(truncating: nonTrialPCKG.product.price)
                case .monthly:
                    productDurationString = "/month"
                    self.monthlyPrice = Float(truncating: nonTrialPCKG.product.price)
                case .weekly:
                    productDurationString = "/week"
                    self.weeklyPrice = Float(truncating: nonTrialPCKG.product.price)
                case .lifetime:
                    productDurationString = "/forever"
                default:
                    print("")
                }
                
                if let nonTrialPrettyPrice = nonTrialPCKG.product.prettyPrice {
                    let boldAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.white]
                    let firstPart = NSMutableAttributedString(string: "Just \(nonTrialPrettyPrice)\(productDurationString)", attributes: boldAttributes)
                    self.priceLabel.attributedText = firstPart
                }
            }
        } else {
            if let trialPCKG = trialPackage {
                
                var productDurationString = ""
                switch trialPCKG.packageType {
                case .annual:
                    productDurationString = " per year"
                    self.annualPrice = Float(truncating: trialPCKG.product.price)
                case .monthly:
                    productDurationString = " per month"
                    self.monthlyPrice = Float(truncating: trialPCKG.product.price)
                case .weekly:
                    productDurationString = " per week"
                    self.weeklyPrice = Float(truncating: trialPCKG.product.price)
                case .lifetime:
                    productDurationString = " / forever"
                default:
                    print("")
                }
                
                var trialString: String = ""
                if let introPrice = trialPCKG.product.introductoryPrice {
                    switch introPrice.subscriptionPeriod.unit {
                    case .day:
                        trialString = " after \(introPrice.subscriptionPeriod.numberOfUnits)-day trial"
                    case .week:
                        trialString = " after \(introPrice.subscriptionPeriod.numberOfUnits)-week trial"
                    default:
                        print("")
                    }
                }
                
                if let nonTrialPrettyPrice = trialPCKG.product.prettyPrice {
                    let boldAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.white]
                    let firstPart = NSMutableAttributedString(string: "\(nonTrialPrettyPrice)\(productDurationString)", attributes: boldAttributes)
                    
                    let trialAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white]
                    let secondPart = NSMutableAttributedString(string: "\(trialString)", attributes: trialAttributes)
                    
                    let thirdAttrString = NSMutableAttributedString.init()
                    thirdAttrString.append(firstPart)
                    thirdAttrString.append(secondPart)
                    
                    self.priceLabel.attributedText = thirdAttrString
                }
            }
        }
    }
    
    
    func setSmallViews() {
        centerView.layer.cornerRadius = 10.0
        leftView.layer.cornerRadius = 10.0
        rightView.layer.cornerRadius = 10.0
    }
    
    func createReviews() -> [ReviewView] {
        var appName = "iPassword"
        if let strongName = Bundle.main.displayName {
            appName = strongName
        }
        
        let review1: ReviewView = Bundle.main.loadNibNamed("ReviewView", owner: self, options: nil)?.first as! ReviewView
        review1.reviewTitleLabel.text = "Best password manager ❤️"
        review1.reviewDateLabel.text = "02 Aug"
        review1.reviewerNameLabel.text = "shayhsayhay21"
        review1.reviewTextLabel.text = "I wanted someplace to keep all my passwords in one place and \(appName) does the job! It even lets me organize the passwords and keep them safe."
        review1.reviewTextLabel.sizeToFit()
        review1.mainView.layer.cornerRadius = 10.0
        
        let review2: ReviewView = Bundle.main.loadNibNamed("ReviewView", owner: self, options: nil)?.first as! ReviewView
        review2.reviewTitleLabel.text = "Love this App!"
        review2.reviewDateLabel.text = "13 May"
        review2.reviewerNameLabel.text = "Easingdale"
        review2.reviewTextLabel.text = "I highly recommend this app to keep your passwords without worrying about security’s issues. It has intuitive interface and glitchless performance."
        review2.reviewTextLabel.sizeToFit()
        review2.mainView.layer.cornerRadius = 10.0
        
        let review3: ReviewView = Bundle.main.loadNibNamed("ReviewView", owner: self, options: nil)?.first as! ReviewView
        review3.reviewTitleLabel.text = "\(appName) is AWESOME"
        review3.reviewDateLabel.text = "1y ago"
        review3.reviewerNameLabel.text = "Uripedes"
        review3.reviewTextLabel.text = "With the myriad of passwords needed for everything as we live in this internet security age, \(appName) keeps me organized and safe. 5 stars!"
        review3.reviewTextLabel.sizeToFit()
        review3.mainView.layer.cornerRadius = 10.0

        return [review1, review2, review3]
    }
    
    func createImages() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = UIImage.init(named: images[i])
            let xPosition = self.imagesContainerView.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.imagesContainerView.frame.width, height: self.imagesContainerView.frame.height)
            imagesScrollView.contentSize.width = imagesContainerView.frame.width * CGFloat(i + 1)
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = false
            imagesScrollView.addSubview(imageView)
         }
    }
    
    func setupSlideScrollView(reviews : [ReviewView]) {
        reviewsScrollView.contentSize = CGSize(width: reviewsScrollView.frame.width * CGFloat(reviews.count), height: reviewsContainerView.frame.height)
        reviewsScrollView.isPagingEnabled = true
        
        for i in 0 ..< reviews.count {
            reviews[i].frame = CGRect(x: reviewsContainerView.frame.width * CGFloat(i), y: 0, width: reviewsContainerView.frame.width, height: reviewsContainerView.frame.height)
            reviewsScrollView.addSubview(reviews[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/reviewsContainerView.frame.width)
        pageControl.currentPage = Int(pageIndex)
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
                
                Amplitude.instance()?.logEvent("paywall_app_purchase_pressed", withEventProperties: eventProperties)
                Analytics.logEvent("paywall_app_purchase_pressed", parameters: eventProperties)
                
                Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                  self.indicator.stopAnimating()
                    self.blackView.isHidden = true
                    if let error = error {
                        if !userCancelled {
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                            Amplitude.instance()?.logEvent("paywall_app_purchase_error", withEventProperties: eventProperties)
                        } else {
                            Amplitude.instance()?.logEvent("paywall_app_purchase_cancel", withEventProperties: eventProperties)
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
                                
                                Amplitude.instance()?.logEvent("paywall_app_purchased", withEventProperties: eventProperties)
                                Analytics.logEvent("paywall_app_purchased", parameters: eventProperties)
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
        Amplitude.instance()?.logEvent("paywall_app_restore_pressed")
        
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
    
    @objc func closePaywall() {
        VibratorEngine.shared.actionTaptic()
        #warning("analytics fix!")
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
    
    override func viewWillLayoutSubviews() {
        setupSlideScrollView(reviews: reviews)
        createImages()
    }
}
