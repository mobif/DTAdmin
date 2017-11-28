//
//  SpecialityTableViewCell.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/1/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SpecialityTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet weak var specialityNameLabel: UILabel!
    @IBOutlet weak var specialityCodeLabel: UILabel!
    @IBOutlet weak var specialityIdLabel: UILabel!
}
