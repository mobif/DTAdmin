//
//  QuestionTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionText: UILabel!
    
    @IBOutlet weak var level: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
