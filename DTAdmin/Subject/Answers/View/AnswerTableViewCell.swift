//
//  AnswerTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var isAnswerCorrectLabel: UILabel!

    func setAnswer(answer: AnswerStructure) {
        answerTextLabel.text = answer.answerText
        if answer.trueAnswer == "1" {
            isAnswerCorrectLabel.text = NSLocalizedString("Right", comment: "Right answer")
        } else {
            isAnswerCorrectLabel.text = NSLocalizedString("Wrong", comment: "Wrong answer")
        }
        if let attachment = answer.attachment {
            attachmentImageView.image = attachment
        } else {
            attachmentImageView.image = UIImage(named: "Image")
        }
    }
    
}
