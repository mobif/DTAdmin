//
//  AddNewQuestionViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionLevelTextField: PickedTextField!
    @IBOutlet weak var questionTypeTextField: PickedTextField!
    @IBOutlet weak var questionAttachmentImageView: UIImageView!
    
    var levels: [String] {
        var array = [String]()
        for i in 1...30 {
            array.append(String(i))
        }
        return array
    }
    
    //var types = ["Simple choice", "Multy choice", "Input field"]
    
    var testId: String?
    var questionId: String?
    var resultModification: ((QuestionStructure) -> ())?
    var updateDates = false
    var question: QuestionStructure? {
        didSet {
            guard let question = question else { return }
            self.view.layoutIfNeeded()
            self.questionTextView.text = question.questionText
            self.questionLevelTextField.text = question.level
            self.questionTypeTextField.text = question.type
            if question.attachment.count > 1 {
                showQuestionAttachment(for: question.attachment)
            }
        }
    }
    var questionForSave: QuestionStructure?

    override func viewDidLoad() {
        super.viewDidLoad()
        if !updateDates {
            self.navigationItem.title = NSLocalizedString("Add new question",
                                                          comment: "Title for AddNewQuestionViewController")
        } else {
            self.navigationItem.title = NSLocalizedString("Update question",
                                                          comment: "Title for AddNewQuestionViewController")
        }
        questionLevelTextField.customDelegate = self
        questionTypeTextField.customDelegate = self

        
        self.questionLevelTextField.dropDownData = levels
        self.questionLevelTextField.tag = 0
        self.questionTypeTextField.dropDownData = types
        self.questionTypeTextField.tag = 1
    }
    
    @IBAction func saveQuestion(_ sender: UIBarButtonItem) {
        if !updateDates {
            saveNewQuestion()
        } else {
            updateQuestion()
        }
    }
    
    func saveNewQuestion() {
        if prepareForSave(){
            guard let questionForSave = questionForSave else { return }
            DataManager.shared.insertEntity(entity: questionForSave, typeEntity: .question) {
                (questionResult, errorMessage) in

                if let errorMessage = errorMessage {
                    self.showWarningMsg(errorMessage)
                } else {
                    guard let result = questionResult as? [[String : Any]] else { return }
                    guard let resultFirst = result.first else { return }
                    guard let questionResult = QuestionStructure(dictionary: resultFirst) else { return }
                    if let resultModification = self.resultModification {
                        resultModification(questionResult)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateQuestion() {
        if prepareForSave(){
            guard let questionId = questionId else { return }
            guard let questionForSave = questionForSave else { return }
            DataManager.shared.updateEntity(byId: questionId, entity: questionForSave, typeEntity: .question) {
                errorMessage in

                if let errorMessage = errorMessage {
                    self.showWarningMsg(errorMessage)
                } else {
                    if let resultModification = self.resultModification {
                        resultModification(questionForSave)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func removeImage(_ sender: UIButton) {
        questionAttachmentImageView.image = nil
    }
    
    func prepareForSave() -> Bool {
        guard let questionText = questionTextView.text,
            let level = questionLevelTextField.text,
            let type = questionTypeTextField.text,
            let testId = testId,
            let typeNumber = types.index(of: type) else { return false }
        
        let typeNumberString = String(typeNumber)
        
        if let attachment: UIImage = questionAttachmentImageView.image {
            let picture = UIImage.encode(fromImage: attachment)
            if questionText.count > 2 {
                let dictionary: [String: Any] = [
                                                 "test_id": testId,
                                                 "question_text": questionText,
                                                 "level": level,
                                                 "type": typeNumberString,
                                                 "attachment": picture
                                                ]
                questionForSave = QuestionStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data",
                                                 comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        } else {
            if questionText.count > 2 {
                let dictionary: [String: Any] = [
                                                 "test_id": testId,
                                                 "question_text": questionText,
                                                 "level": level,
                                                 "type": typeNumberString,
                                                 "attachment": ""
                                                ]
                questionForSave = QuestionStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data",
                                                 comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        }
    }
    
    func showQuestionAttachment(for text: String){
        questionAttachmentImageView.image = UIImage.decode(fromBase64: text)
    }
    
}

extension AddNewQuestionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
            let imageHeight: CGFloat = 100.0
            let aspectRatioForWidth = ( size.width / size.height ) * imageHeight
            let resizedImage = image.resize(toSize: CGSize(width: aspectRatioForWidth, height: imageHeight),
                                            scale: UIScreen.main.scale)
            questionAttachmentImageView.image = resizedImage
        } else {
            showWarningMsg(NSLocalizedString("Image not selected!",
                                             comment: "You have to select image to adding in profile."))
        }

        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewQuestionViewController: PickerDelegate {

    func pickedValue(value: Any, tag: Int) {
        if let stringValue = value as? String {
            switch tag {
            case 0:
                self.questionLevelTextField.text = stringValue
            case 1:
                self.questionTypeTextField.text = stringValue
            default:
                break
            }
        }
    }
}
