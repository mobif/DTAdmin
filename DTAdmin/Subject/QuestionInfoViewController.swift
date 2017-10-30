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
    
    var question: Question? {
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
