//
//  QuestionInfoViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/27/17.
//  Copyright © 2017 if-ios-077. All rights reserved.

//  Question: {question_id, test_id, question_text, level, type, attachment}


import UIKit

class QuestionInfoViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var questionLevelLabel: UILabel!
    
    @IBOutlet weak var questionTypeLabel: UILabel!
    
    @IBOutlet weak var questionAttachmentImageView: UIImageView!
    
    var question: QuestionStructure? {
        didSet {
            guard let question = question else { return }
            self.view.layoutIfNeeded()
            self.questionLabel.text = question.questionText
            self.questionLevelLabel.text = "Level: " + question.level
            self.questionTypeLabel.text = "Type" + question.type
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let question = question else { return }
        print(question.questionText)
        print(question.level)
        print(question.type)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
