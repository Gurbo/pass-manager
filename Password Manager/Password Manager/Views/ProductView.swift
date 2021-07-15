//
//  ProductView.swift
//  vibro
//
//  Created by Alex Gurbo on 9/15/20.
//  Copyright © 2020 Alex Gurbo. All rights reserved.
//

import UIKit
import StoreKit
import Purchases

enum State: Int {
    case nonactive
    case active
}

class ProductView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var radioButtonImageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    var package: Purchases.Package?
    var state: State? {
        willSet(newState) {
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 2.0
            switch newState {
            case .nonactive:
                self.backgroundColor = UIColor.clear
                self.radioButtonImageView.image = nil
                self.priceLabel.textColor = UIColor.white
                self.nameLabel.textColor = UIColor.white
            case .active:
                self.backgroundColor = UIColor.white
                self.radioButtonImageView.image = UIImage.init(named: "check")
                self.priceLabel.textColor = UIColor.init(red: 242.0/255.0, green: 92.0/255.0, blue: 84.0/255.0, alpha: 1.0)
                self.nameLabel.textColor = UIColor.init(red: 242.0/255.0, green: 92.0/255.0, blue: 84.0/255.0, alpha: 1.0)
            case .none:
                print("")
            }
        }
    }

    required override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
}
