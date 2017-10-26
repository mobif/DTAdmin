//
//  TestTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var testName: UILabel!
    
    @IBOutlet weak var testTask: UILabel!
    
    @IBOutlet weak var timeForTest: UILabel!
    
    @IBOutlet weak var attempts: UILabel!
    
    @IBOutlet weak var enabled: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
