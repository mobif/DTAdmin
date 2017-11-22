//
//  AddNewAnswerViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewAnswerViewController: UIViewController {
   
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var isAnswerCorrectTextField: UITextField!
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    let isAnswerCorrect = [
                        NSLocalizedString("Wrong", comment: "Wrong answer"),
                           NSLocalizedString("Right", comment: "Right answer")
                        ]
    var questionId: String?
    var qustionType: String?
    var updateDates = false
    var resultModification: ((AnswerStructure) -> ())?
    var answerForSave: AnswerStructure?
    var answer: AnswerStructure? {
        didSet {
            guard let answer = answer else { return }
            self.view.layoutIfNeeded()
            self.answerTextView.text = answer.answerText
            self.isAnswerCorrectTextField.text = answer.trueAnswer
            if answer.attachment.count > 1 {
                showAnswerAttachment(for: answer.attachment)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !updateDates {
            self.navigationItem.title = NSLocalizedString("Add new answer",
                                                          comment: "Title for AddNewAnswerViewController")
        } else {
            self.navigationItem.title = NSLocalizedString("Update answer",
                                                          comment: "Title for AddNewAnswerViewController")
        }

        if qustionType == "3" || qustionType == "4" {
            isAnswerCorrectTextField.text = isAnswerCorrect[1]
            isAnswerCorrectTextField.isEnabled = false
        } else {
            let isAnswerCorrect = UITapGestureRecognizer(target: self, action: #selector(chooseAnswerCorrect))
            isAnswerCorrectTextField.addGestureRecognizer(isAnswerCorrect)
        }
    }

    @objc func chooseAnswerCorrect() {
        guard let itemTableViewController = UIStoryboard(name: "Subjects",
                                                         bundle: nil).instantiateViewController(withIdentifier:
                                                            "ItemTableViewController") as?
            ItemTableViewController else { return }
        itemTableViewController.currentArray = isAnswerCorrect
        itemTableViewController.navigationItem.title = NSLocalizedString("Answer correctness",
                                                                         comment: "Title for ItemTableViewController")
        itemTableViewController.resultModification = { result in
            self.isAnswerCorrectTextField.text = result
        }
        self.navigationController?.pushViewController(itemTableViewController, animated: true)
    }
    
    func showAnswerAttachment(for text: String) {
        attachmentImageView.image = UIImage.decode(fromBase64: text)
    }
    
    @IBAction func saveAnswer(_ sender: UIBarButtonItem) {
        if !updateDates {
            saveNewAnswer()
        } else {
            updateAnswer()
        }
    }
    
    func saveNewAnswer() {
        if prepareForSave(){
            guard let answerForSave = answerForSave else { return }
            DataManager.shared.insertEntity(entity: answerForSave, typeEntity: .answer) {
                (answerResult, errorMessage) in

                if let errorMessage = errorMessage {
                    self.showWarningMsg(errorMessage)
                } else {
                    guard let result = answerResult as? [[String : Any]] else { return }
                    guard let resultFirst = result.first else { return }
                    guard let answer = AnswerStructure(dictionary: resultFirst) else { return }
                    if let resultModification = self.resultModification {
                        resultModification(answer)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateAnswer() {
        if prepareForSave(){
            guard let answerId = answer?.id else { return }
            guard let answerForSave = answerForSave else { return }
            DataManager.shared.updateEntity(byId: answerId, entity: answerForSave, typeEntity: .answer) {
                errorMessage in

                if let errorMessage = errorMessage {
                    self.showWarningMsg(errorMessage)
                } else {
                    if let resultModification = self.resultModification {
                        resultModification(answerForSave)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func prepareForSave() -> Bool {
    
        guard let id = questionId else { return false }
        
        guard let answerText = answerTextView.text,
            let trueAnswer = isAnswerCorrectTextField.text,
            let correctnessNumber = isAnswerCorrect.index(of: trueAnswer) else { return false }
        
        let correctnessNumberString = String(correctnessNumber)
        
        if let attachment: UIImage = attachmentImageView.image {
            let picture = UIImage.encode(fromImage: attachment)
            if answerText.count >= 1 {
                let dictionary: [String: Any] = [
                                                 "question_id": id,
                                                 "true_answer": correctnessNumberString,
                                                 "answer_text": answerText,
                                                 "attachment": picture
                                                ]
                answerForSave = AnswerStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data",
                                                 comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        } else {
            if answerText.count >= 1 {
                let dictionary: [String: Any] = [
                                                 "question_id": id,
                                                 "true_answer": correctnessNumberString,
                                                 "answer_text": answerText,
                                                 "attachment": ""
                                                ]
                answerForSave = AnswerStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data",
                                                 comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        }
    }
    
    @IBAction func removeImage(_ sender: UIButton) {
        attachmentImageView.image = nil
    }
    
}

extension AddNewAnswerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func openGallery(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let size = image.size
            let resizedImage = image.resize(toSize: CGSize(width: ( size.width / size.height ) * 100.0,
                                                           height: 100.0),
                                            scale: UIScreen.main.scale)
            attachmentImageView.image = resizedImage
        } else {
            showWarningMsg(NSLocalizedString("Image not selected!",
                                             comment: "You have to select image to adding in profile."))
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewAnswerViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if qustionType == "3" || qustionType == "4" {
            var result = true
            let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789.-")
            let replacementStringIsLegal = text.rangeOfCharacter(from: disallowedCharacterSet as CharacterSet)
            result = (replacementStringIsLegal != nil)
            return result
        }
        return true
    }

}

