//
//  SwitchPaywallViewController.swift
//  Password Manager
//
//  Created by Alex on 19.08.21.
//

import UIKit

class SwitchPaywallViewController: UIViewController, UIScrollViewDelegate {

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

    
    
    
    var reviews: [ReviewView] = []
    var scrollTimer: Timer?

    let images = ["happy_1","happy_2","happy_3"]
    var scrollImageTimer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviews = createReviews()
        createImages()
        setSmallViews()
        
        pageControl.numberOfPages = reviews.count
        pageControl.currentPage = 0
        
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
        //purchaseButton.addTarget(self, action: #selector(showFirstOnboardingScreen), for: .touchUpInside)
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
            let xPosition = self.imagesContainerView.frame.width * CGFloat(i)
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
    
    override func viewWillLayoutSubviews() {
        setupSlideScrollView(reviews: reviews)
    }
}
