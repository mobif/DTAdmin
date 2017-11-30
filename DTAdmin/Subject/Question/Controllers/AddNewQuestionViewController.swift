//
//  AddNewQuestionViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewQuestionViewController: ParentViewController {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionLevelTextField: UITextField!
    @IBOutlet weak var questionTypeTextField: UITextField!
    @IBOutlet weak var questionAttachmentImageView: UIImageView!
    
    var levels: [String] {
        var array = [String]()
        for i in 1...30 {
            array.append(String(i))
        }
        return array
    }
    
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
            guard let index = Int(question.type) else { return }
            self.questionTypeTextField.text = types[index - 1]
            if let attachment = question.attachment {
               questionAttachmentImageView.image = attachment
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

        tapGestureRecognizerConfigure()
    }

    private func tapGestureRecognizerConfigure() {
        let questionLevel = UITapGestureRecognizer(target: self, action: #selector(chooseQuestionLevel))
        questionLevelTextField.addGestureRecognizer(questionLevel)
        let questionType = UITapGestureRecognizer(target: self, action: #selector(chooseQuestionType))
        questionTypeTextField.addGestureRecognizer(questionType)
    }

    @objc private func chooseQuestionLevel() {
        guard let itemTableViewController = UIStoryboard(name: "Subjects",
                                                                  bundle: nil).instantiateViewController(withIdentifier: "ItemTableViewController") as?
            ItemTableViewController else { return }
        itemTableViewController.currentArray = levels
        itemTableViewController.navigationItem.title = NSLocalizedString("Question level",
                                                                         comment: "Title for ItemTableViewController")
        itemTableViewController.resultModification = { result in
            self.questionLevelTextField.text = result
        }
        self.navigationController?.pushViewController(itemTableViewController, animated: true)
    }

    @objc private func chooseQuestionType() {
        guard let itemTableViewController = UIStoryboard(name: "Subjects",
                                                         bundle: nil).instantiateViewController(withIdentifier:
                                                            "ItemTableViewController") as?
            ItemTableViewController else { return }
        itemTableViewController.currentArray = types
        itemTableViewController.navigationItem.title = NSLocalizedString("Question type",
                                                                         comment: "Title for ItemTableViewController")
        itemTableViewController.resultModification = { result in
            self.questionTypeTextField.text = result
        }
        self.navigationController?.pushViewController(itemTableViewController, animated: true)
    }
    
    @IBAction func saveQuestion(_ sender: UIBarButtonItem) {
        if !updateDates {
            saveNewQuestion()
        } else {
            updateQuestion()
        }
    }
    
    private func saveNewQuestion() {
        if prepareForSave(){
            guard let questionForSave = questionForSave else { print("Baddddd"); return }
            DataManager.shared.insertEntity(entity: questionForSave, typeEntity: .question) {
                (questionResult, error) in

                if let errorMessage = error {
                    self.showAllert(error: errorMessage, completionHandler: nil)
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
    
    private func updateQuestion() {
        if prepareForSave(){
            guard let questionId = questionId else { return }
            guard let questionForSave = questionForSave else { return }
            DataManager.shared.updateEntity(byId: questionId, entity: questionForSave, typeEntity: .question) {
                errorMessage in

                if let errorMessage = errorMessage {
                    self.showAllert(error: errorMessage, completionHandler: nil)
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
    
    private func prepareForSave() -> Bool {
        guard let questionText = questionTextView.text,
            let level = questionLevelTextField.text,
            let type = questionTypeTextField.text,
            let testId = testId,
            let typeNumber = types.index(of: type) else { return false }
        
        let typeNumberString = String(typeNumber + 1)

        if questionText.count > minCountOfText {
            let dictionary: [String: Any] = [
                "test_id": testId,
                "question_text": questionText,
                "level": level,
                "type": typeNumberString
            ]
        questionForSave = QuestionStructure(dictionary: dictionary)
        if let image: UIImage = questionAttachmentImageView.image{
            questionForSave?.attachment = image
            }
        } else {
            showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
            return false
            }
        return true
        }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
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

