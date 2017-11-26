//
//  QuestionAttachmentViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/14/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class QuestionAttachmentViewController: ParentViewController {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionAttachmentImageView: UIImageView!
    
    var questionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Question detail",
                                                      comment: "Title for QuestionAttachmentViewController")

        showQuestionRecord()
    }
    
    private func showQuestionRecord() {
        startActivity()
        guard let id = questionId else { return }
        DataManager.shared.getEntity(byId: id, typeEntity: .question) {(questionRecord, errorMessage) in
            self.stopActivity()
            if errorMessage == nil {
                guard let question = questionRecord as? QuestionStructure else { return }
                self.questionTextLabel.text = question.questionText
                if question.attachment.count > 0 {
                    self.questionAttachmentImageView.image = UIImage.decode(fromBase64: question.attachment)
                } else {
                    self.questionAttachmentImageView.image = UIImage(named: "Image")
                }
            } else {
                self.showWarningMsg(errorMessage?.message ??
                    NSLocalizedString("Incorect type data", comment: "Message for user about incorect data"))
            }
        }
    }

}

extension QuestionAttachmentViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.questionAttachmentImageView
    }
    
}
