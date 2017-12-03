//
//  ResultsTableTestViewCell.swift
//  DTAdmin
//
//  Created by Yurii Krupa on 11/11/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class ResultsTableTestViewCell: UITableViewCell {
    
    @IBOutlet weak var testIdLabel: UILabel!
    @IBOutlet weak var testNameLabel: UILabel!
    @IBOutlet weak var testSubjectNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
