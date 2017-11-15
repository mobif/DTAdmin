//
//  AnswerTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attachment: UIImageView!
    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var trueAnswer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
