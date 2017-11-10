//
//  QuestionTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/10/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol QuestionTableViewCellDelegate {
    
    func didTapShowAnswer(id: String)
}


class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionTextLabel: UILabel!
    
    @IBOutlet weak var questionLevelLabel: UILabel!
    
    @IBOutlet weak var questionTypeLabel: UILabel!
    
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    var questionItem: QuestionStructure!
    var delegate: QuestionTableViewCellDelegate?
    
    func setQuestion(question: QuestionStructure) {
        questionItem = question
        questionTextLabel.text = question.questionText
        questionLevelLabel.text = "Level: " + question.level
        questionTypeLabel.text = "Type: " + question.type
        if question.attachment.count > 0 {
            let photoBase64 = question.attachment
            guard let dataDecoded : Data = Data(base64Encoded: photoBase64, options: .ignoreUnknownCharacters) else { return }
            let decodedimage = UIImage(data: dataDecoded)
            attachmentImageView.image = decodedimage
        } else {
            attachmentImageView.image = UIImage(named: "Image")
        }
    }
    
    @IBAction func showAnswers(_ sender: UIButton) {
        guard let id = questionItem.id else { return }
        delegate?.didTapShowAnswer(id: id)
    }

    
}
