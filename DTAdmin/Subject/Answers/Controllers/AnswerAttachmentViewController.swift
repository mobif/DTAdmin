//
//  AnswerAttachmentViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AnswerAttachmentViewController: ParentViewController {

    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var answerAttachmentImageView: UIImageView!
    
    var answerId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Answer detail",
                                                      comment: "Title for AnswerAttachmentViewController")
        
        showAnswerRecord()
    }
    
    private func showAnswerRecord() {
        startActivity()
        guard let id = answerId else { return }
        DataManager.shared.getEntity(byId: id, typeEntity: .answer) {(answerRecord, error) in
            self.stopActivity()
            if let errorMessage = error {
                self.showAllert(error: errorMessage, completionHandler: nil)
            } else {
                guard let answer = answerRecord as? AnswerStructure else { return }
                self.answerTextLabel.text = answer.answerText
                if let attachment = answer.attachment {
                    self.answerAttachmentImageView.image = attachment
                } else {
                    self.answerAttachmentImageView.image = UIImage(named: "Image")
                }
            }

        }
    }
}

// MARK: - UIScrollViewDelegate
extension AnswerAttachmentViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.answerAttachmentImageView
    }

}
