//
//  AddNewQuestionViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.


//  Question: {question_id, test_id, question_text, level, type, attachment}



import UIKit

class AddNewQuestionViewController: UIViewController {

    @IBOutlet weak var qustionTextField: UITextField!
    
    @IBOutlet weak var questionLevelTextField: UITextField!
    
    @IBOutlet weak var questionTypeTextField: UITextField!
    
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
    
    @IBAction func addNewQuestion(_ sender: UIButton) {
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
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = updateDates ? "Update question" : "Add new question"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
