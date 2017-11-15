//
//  AnswerAttachmentViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AnswerAttachmentViewController: ParentViewController, UIScrollViewDelegate {

    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var answerAttachmentImageView: UIImageView!
    
    var answerId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Answer detail"
        showAnswerRecord()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showAnswerRecord() {
        startActivity()
        guard let id = answerId else { return }
        DataManager.shared.getEntity(byId: id, typeEntity: .answer) {(answerRecord, errorMessage) in
            self.stopActivity()
            if errorMessage == nil {
                guard let answer = answerRecord as? AnswerStructure else { return }
                self.answerTextLabel.text = answer.answerText
                if answer.attachmant.count > 0 {
                    self.answerAttachmentImageView.image = UIImage.convert(fromBase64: answer.attachmant)
                } else {
                    self.answerAttachmentImageView.image = UIImage(named: "Image")
                }
            } else {
                self.showWarningMsg(NSLocalizedString(errorMessage ?? "Incorect type data", comment: "Message for user") )
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.answerAttachmentImageView
    }
}
