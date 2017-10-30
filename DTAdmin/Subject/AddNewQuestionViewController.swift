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
    var levelPickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    var selectedDay: String?
    
    var testId: String = ""
    var questionId: String = ""
    var saveAction: ((Question?) -> ())?
    var updateDates = false
    var question: Question? {
        didSet {
            guard let question = question else { return }
            self.view.layoutIfNeeded()
            self.qustionTextField.text = question.questionText
            self.questionLevelTextField.text = question.level
            self.questionTypeTextField.text = question.type
        }
    }
    
    @IBAction func saveQuestion(_ sender: UIBarButtonItem) {
        guard let questionText = qustionTextField.text else { return }
        guard let questionLevel = questionLevelTextField.text else { return }
        guard let questionType = questionTypeTextField.text else { return }
        
        if !questionText.isEmpty && !questionLevel.isEmpty && !questionType.isEmpty {
            if !updateDates{
                Question.postRequests(parameters : ["test_id" : testId, "question_text" : questionText, "level" : questionLevel, "type" : questionType, "attachment" : ""], sufix : "InsertData", completion: { (item: [Question]?, code:Int) in
                    DispatchQueue.main.async {
                        if code == 200 {
                            guard let data = item else {
                                self.showMessage(message: NSLocalizedString("Server error. Record isn't add!", comment: "Message for user"))
                                return
                            }
                            if data.count > 0 {
                                self.saveAction?(data[0])
                                self.navigationController?.popViewController(animated: true)
                                
                            } else {
                                self.showMessage(message: NSLocalizedString("Server error.\n Record isn't add!", comment: "Message for user"))
                            }
                        } else {
                            self.showMessage(message: NSLocalizedString("Duplicate data! Please, write another information", comment: "Message for user"))
                        }
                        
                    }
                })
            } else {
                Question.postRequests(parameters : ["test_id" : testId, "question_text" : questionText, "level" : questionLevel, "type" : questionType, "attachment" : ""], sufix : "update/\(questionId)", completion: { (item: [Question]?, code:Int) in
                    DispatchQueue.main.async {
                        if code == 200 {
                            guard let data = item else {
                                self.showMessage(message: NSLocalizedString("Server error. Record isn't add!", comment: "Message for user"))
                                return
                            }
                            if data.count > 0 {
                                self.saveAction?(data[0])
                                self.navigationController?.popViewController(animated: true)
                                
                            } else {
                                self.showMessage(message: NSLocalizedString("Server error.\n Record isn't add!", comment: "Message for user"))
                            }
                        } else {
                            self.showMessage(message: NSLocalizedString("Duplicate data! Please, write another information", comment: "Message for user"))
                        }
                        
                    }
                })
            }
        } else {
            self.showMessage(message: NSLocalizedString("Please, enter all fields!", comment: "Message for user"))
        }    }
    
  
    
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
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = updateDates ? "Update question" : "Add new question"
        questionLevelTextField.delegate = self
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
        dayPicker.tag = 0
        dayPicker.delegate = self
        questionLevelTextField.inputView = dayPicker
        questionTypeTextField.inputView = dayPicker

    }
    
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.tag = 1
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewQuestionViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        questionLevelTextField.inputAccessoryView = toolBar
        questionTypeTextField.inputAccessoryView = toolBar
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        return activeField = textField
//    }
    
}

extension AddNewQuestionViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        <#code#>
//    }
    
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
        questionLevelTextField.text = selectedDay
        questionTypeTextField.text = selectedDay
    }
    
}
