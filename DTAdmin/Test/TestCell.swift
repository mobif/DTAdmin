//
//  TestCell.swift
//  DTAdmin
//
//  Created by Anastasia Kinelska on 11/2/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {
    
    @IBOutlet weak var testName: UILabel!
    @IBOutlet weak var timeForTest: UILabel!
    @IBOutlet weak var attempts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
