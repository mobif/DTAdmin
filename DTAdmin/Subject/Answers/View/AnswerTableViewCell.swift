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
    @IBOutlet weak var trueAnswerLabel: UILabel!

    func setAnswer(answer: AnswerStructure) {
        answerTextLabel.text = answer.answerText
        let answerTrue = answer.trueAnswer == "1" ? "Right" : "Wrong"
        trueAnswerLabel.text = answerTrue
        if answer.attachmant.count > 0 {
            attachmentImageView.image = UIImage.convert(fromBase64: answer.attachmant)
        } else {
            attachmentImageView.image = UIImage(named: "Image")
        }
    }
    
}
