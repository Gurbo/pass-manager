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

            switch newState {
            case .nonactive:
                self.layer.borderColor = UIColor.init(hex: kMintColor).cgColor
                self.layer.borderWidth = 0.0
                self.backgroundColor = UIColor.init(hex: kCellColor)
                self.radioButtonImageView.image = nil
                self.priceLabel.textColor = UIColor.white
                self.nameLabel.textColor = UIColor.white
            case .active:
                self.layer.borderColor = UIColor.init(hex: kMintColor).cgColor
                self.layer.borderWidth = 1.5
                self.backgroundColor = UIColor.init(hex: kCellColor)
                self.radioButtonImageView.image = UIImage.init(named: "check")
                self.priceLabel.textColor = UIColor.white
                self.nameLabel.textColor = UIColor.white
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
