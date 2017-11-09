//
//  AddNewQuestionViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewQuestionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PickerDelegate  {
    
    @IBOutlet weak var qustionTextField: UITextField!
    
    @IBOutlet weak var questionLevelTextField: PickedTextField!
    
    @IBOutlet weak var questionTypeTextField: PickedTextField!
    
    @IBOutlet weak var questionAttachmentImageView: UIImageView!
    
    var levels: [Int] {
        var array = [Int]()
        for i in 1...30 {
            array.append(i)
        }
        return array
    }
    
    var types: [Int] {
        var array = [Int]()
        for i in 1...3 {
            array.append(i)
        }
        return array
    }
    
    var testId: String = ""
    var questionId: String?
    var resultModification: ((QuestionStructure) -> ())?
    var updateDates = false
    var question: QuestionStructure? {
        didSet {
            guard let question = question else { return }
            self.view.layoutIfNeeded()
            self.qustionTextField.text = question.questionText
            self.questionLevelTextField.text = question.level
            self.questionTypeTextField.text = question.type
            if question.attachment.count > 1 {
                showQuestionAttachment()
            }
        }
    }
    var questionForSave: QuestionStructure?
    
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
            DataManager.shared.insertEntity(entity: questionForSave, typeEntity: .question) { (questionResult, error) in
                if let error = error {
                    self.showWarningMsg(error)
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
            DataManager.shared.updateEntity(byId: questionId, entity: questionForSave, typeEntity: .question) { error in
                if let error = error {
                    self.showWarningMsg(error)
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
        questionAttachmentImageView.image = UIImage(named: "Image")
    }
    
    func prepareForSave() -> Bool {
        guard let questionText = qustionTextField.text,
            let level = questionLevelTextField.text,
            let type = questionTypeTextField.text else { return false }
        
        if let attachment : UIImage = questionAttachmentImageView.image, let attachmentData = UIImagePNGRepresentation(attachment) {
            let picture = attachmentData.base64EncodedString(options: .lineLength64Characters)
            if questionText.count > 2 {
                let dictionary: [String: Any] = ["test_id": testId, "question_text": questionText, "level": level, "type": type, "attachment": picture]
                print(testId)
                print(questionText)
                print(level)
                print(type)
                questionForSave = QuestionStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        } else {
            if questionText.count > 2 {
                let dictionary: [String: Any] = ["test_id": testId, "question_text": questionText, "level": level, "type": type, "attachment": ""]
                print(testId)
                print(questionText)
                print(level)
                print(type)
                questionForSave = QuestionStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        }
    }
    
    func showQuestionAttachment(){
        guard let photoBase64 = question?.attachment else { return }
        guard let dataDecoded : Data = Data(base64Encoded: photoBase64, options: .ignoreUnknownCharacters) else { return }
        let decodedimage = UIImage(data: dataDecoded)
        questionAttachmentImageView.image = decodedimage
    }
    
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
            let resizedImage = image.convert(toSize: CGSize(width: aspectRatioForWidth, height: imageHeight), scale: UIScreen.main.scale)
            questionAttachmentImageView.image = resizedImage
        } else {
            showWarningMsg(NSLocalizedString("Image not selected!", comment: "You have to select image to adding in profile."))
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = updateDates ? "Update question" : "Add new question"
        questionLevelTextField.customDelegate = self
        questionTypeTextField.customDelegate = self
        questionAttachmentImageView.layer.cornerRadius = 5
        questionAttachmentImageView.layer.borderWidth = 1
        questionAttachmentImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        
        self.questionLevelTextField.dropDownData = levels
        self.questionTypeTextField.tag = 0
        self.questionTypeTextField.dropDownData = types
        self.questionTypeTextField.tag = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pickedValue(value: Any, tag: Int) {
        if let intValue = value as? Int {
            switch tag {
            case 0:
                self.questionLevelTextField.text = String(intValue)
            case 1:
                self.questionTypeTextField.text = String(intValue)
            default:
                break
            }
        }
    }
    
}
