//
//  AddNewQuestionViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.


//  Question: {question_id, test_id, question_text, level, type, attachment}



import UIKit

class AddNewQuestionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var qustionTextField: UITextField!
    
    @IBOutlet weak var questionLevelTextField: UITextField!
    
    @IBOutlet weak var questionTypeTextField: UITextField!
    
    @IBOutlet weak var questionAttachmentImageView: UIImageView!
    
    var typePickerData = ["1", "2", "3"]
    
    var selectedDay: String?
    
    var testId: String = ""
    var questionId: String?
    var resultModification: ((QuestionStructure, Bool) -> ())?
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
            if prepareForSave(){
                print(questionForSave)
                guard let questionForSave = questionForSave else { return }
                
                DataManager.shared.insertEntity(entity: questionForSave, typeEntity: .Question) { (id, error) in
                    if let error = error {
                        self.showWarningMsg(error)
                    } else {
                        guard let id = id else {
                            self.showWarningMsg(NSLocalizedString("Incorect response structure", comment: "New user ID not found in the response message"))
                            return
                        }
                        let newUserId = String(describing: id)
                        var newStudent = questionForSave
                        newStudent.id = newUserId
                        if let resultModification = self.resultModification {
                            resultModification(newStudent, true)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            if prepareForSave(){
                guard let questionId = questionId else { return }
                guard let questionForSave = questionForSave else { return }
                DataManager.shared.updateEntity(byId: questionId, entity: questionForSave, typeEntity: .Question) { error in
                    if let error = error {
                        self.showWarningMsg(error)
                    } else {
                        if let resultModification = self.resultModification {
                            resultModification(questionForSave, false)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
    }
    
    func prepareForSave() -> Bool {
        guard let questionText = qustionTextField.text,
            let level = questionLevelTextField.text,
            let type = questionTypeTextField else { return false }
        guard let attachment : UIImage = questionAttachmentImageView.image,
            let attachmentData = UIImagePNGRepresentation(attachment) else { return false }
        let picture = attachmentData.base64EncodedString(options: .lineLength64Characters)
        if questionText.count > 1 {
            let dictionary: [String: Any] = ["test_id": testId, "question_text": questionText, "level": level, "type": type, "attachment": ""]
            print(dictionary)
            questionForSave = QuestionStructure(dictionary: dictionary)
            print(questionForSave)
        } else {
            showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
            return false
        }
        return true
    }
    
    func showQuestionAttachment(){
        guard let photoBase64 = question?.attachment else { return }
        guard let dataDecoded : Data = Data(base64Encoded: photoBase64, options: .ignoreUnknownCharacters) else { return }
        let decodedimage = UIImage(data: dataDecoded)
        questionAttachmentImageView.image = decodedimage
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            questionAttachmentImageView.image = image
        } else {
            showWarningMsg(NSLocalizedString("Image not selected!", comment: "You have to select image to adding in profile."))
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = updateDates ? "Update question" : "Add new question"
        questionTypeTextField.delegate = self
        createDayPicker()
        createToolbar()
        questionAttachmentImageView.layer.cornerRadius = 5
        questionAttachmentImageView.layer.borderWidth = 1
        questionAttachmentImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createDayPicker() {
        let dayPicker = UIPickerView()
        //dayPicker.tag = 0
        dayPicker.delegate = self
        questionTypeTextField.inputView = dayPicker
    }

    func createToolbar() {
        let toolBar = UIToolbar()
        //toolBar.tag = 0
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewQuestionViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        questionTypeTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension AddNewQuestionViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typePickerData.count
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typePickerData[row]
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedDay = typePickerData[row]
            questionTypeTextField.text = selectedDay
    }

}

