//
//  AddNewAnswerViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewAnswerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PickerDelegate  {
    
    func pickedValue(value: Any, tag: Int) {
        if let intValue = value as? Int {
            switch tag {
            case 0:
                self.trueAnswerTextField.text = String(intValue)
            default:
                break
            }
        }
    }
    
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var trueAnswerTextField: PickedTextField!
    
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    var correctmess = ["True", "False"]
    var questionId: String?
    var updateDates = false
    var resultModification: ((AnswerStructure) -> ())?
    var answerForSave: AnswerStructure?
    var answer: AnswerStructure? {
        didSet {
            guard let answer = answer else { return }
            self.view.layoutIfNeeded()
            self.answerTextField.text = answer.answerText
            self.trueAnswerTextField.text = answer.trueAnswer
            if answer.attachmant.count > 1 {
                showAnswerAttachment()
            }
        }
    }
    
    let trueAnswer = [0, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = updateDates ? "Update answer" : "Add new answer"
        guard let id = questionId else { return }
        print("Add new " + id)
        attachmentImageView.layer.cornerRadius = 5
        attachmentImageView.layer.borderWidth = 1
        attachmentImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        trueAnswerTextField.customDelegate = self
        self.trueAnswerTextField.dropDownData = trueAnswer
        self.trueAnswerTextField.tag = 0
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAnswerAttachment() {
        guard let photoBase64 = answer?.attachmant else { return }
        guard let dataDecoded : Data = Data(base64Encoded: photoBase64, options: .ignoreUnknownCharacters) else { return }
        let decodedimage = UIImage(data: dataDecoded)
        attachmentImageView.image = decodedimage
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
            DataManager.shared.insertEntity(entity: answerForSave, typeEntity: .answer) { (answerResult, error) in
                if let error = error {
                    self.showWarningMsg(error)
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
            DataManager.shared.updateEntity(byId: answerId, entity: answerForSave, typeEntity: .answer) { error in
                if let error = error {
                    self.showWarningMsg(error)
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
        
        guard let answerText = answerTextField.text,
            let trueAnswer = trueAnswerTextField.text else { return false }
        
        if let attachment : UIImage = attachmentImageView.image, let attachmentData = UIImagePNGRepresentation(attachment) {
            let picture = attachmentData.base64EncodedString(options: .lineLength64Characters)
            if answerText.count >= 1 {
                let dictionary: [String: Any] = ["question_id": id, "true_answer": trueAnswer, "answer_text": answerText, "attachment": picture]
                print(trueAnswer)
                print(answerText)
                answerForSave = AnswerStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        } else {
            if answerText.count >= 1 {
                let dictionary: [String: Any] = ["question_id": id, "true_answer": trueAnswer, "answer_text": answerText, "attachment": ""]
                print(trueAnswer)
                print(answerText)
                answerForSave = AnswerStructure(dictionary: dictionary)
            } else {
                showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
                return false
            }
            return true
        }
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
            attachmentImageView.image = resizedImage
        } else {
            showWarningMsg(NSLocalizedString("Image not selected!", comment: "You have to select image to adding in profile."))
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeImage(_ sender: UIButton) {
        attachmentImageView.image = UIImage(named: "Image")
    }
    
    
}
