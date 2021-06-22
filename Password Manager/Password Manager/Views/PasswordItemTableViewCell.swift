//
//  PasswordItemTableViewCell.swift
//  Password Manager
//
//  Created by Alex Gurbo on 6/21/21.
//

import UIKit

class PasswordItemTableViewCell: UITableViewCell {
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
