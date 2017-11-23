//
//  QuestionTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/10/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol QuestionTableViewCellDelegate {
    /**
        Sends to the AnswerViewController
        - Parameter id: Send question id to the next View Controller for create request and making call's to API
     */
    func didTapShowAnswer(for id: String, and type: String)
}

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var questionLevelLabel: UILabel!
    @IBOutlet weak var questionTypeLabel: UILabel!
    
    var questionItem: QuestionStructure?
    var delegate: QuestionTableViewCellDelegate?
    
    func setQuestion(question: QuestionStructure) {
        questionItem = question
        questionTextLabel.text = question.questionText

        let levelQuestionText = NSLocalizedString("Level of difficulty: ", comment: "Level of difficulty question")
        questionLevelLabel.text = levelQuestionText + question.level
        
        let typeQuestionText = NSLocalizedString("Type of question: ", comment: "Type of question")
        guard let index = Int(question.type) else { return }
        questionTypeLabel.text = typeQuestionText + types[index - 1]
    }
    
    @IBAction func showAnswers(_ sender: UIButton) {
        guard let id = questionItem?.id else { return }
        guard let type = questionItem?.type else { return }
        delegate?.didTapShowAnswer(for: id, and: type)
    }

}
