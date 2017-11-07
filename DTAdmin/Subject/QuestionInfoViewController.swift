//
//  QuestionInfoViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

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
            self.questionTypeLabel.text = "Type: " + question.type
            if question.attachment.count > 1 {
                showQuestionAttachment()
            }
        }
    }
    
    func showQuestionAttachment(){
        guard let photoBase64 = question?.attachment else { return }
        guard let dataDecoded : Data = Data(base64Encoded: photoBase64, options: .ignoreUnknownCharacters) else { return }
        let decodedimage = UIImage(data: dataDecoded)
        questionAttachmentImageView.image = decodedimage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Question Info"
        guard let question = question else { return }
        print(question.questionText)
        print(question.level)
        print(question.type)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
