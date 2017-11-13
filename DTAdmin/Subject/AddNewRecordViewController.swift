//
//  AddNewRecordViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewRecordViewController: UIViewController {

    @IBOutlet weak var subjectNameTextField: UITextField!
    
    @IBOutlet weak var subjectDescriptionTextField: UITextView!
    
    var updateDates = false
    var subjectId: String = ""
    let queryService = QueryService()
    var saveAction: ((Subject?) -> ())?
    var item: Subject?
    var subject: Subject? {
        didSet {
            guard let subject = subject else { return }
            self.view.layoutIfNeeded()
            self.subjectNameTextField.text = subject.name
            self.subjectDescriptionTextField.text = subject.description
        }
    }
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveNewRecord(_ sender: UIButton) {
        guard let name = subjectNameTextField.text else { return }
        guard let description = subjectDescriptionTextField.text else { return }
        
        if !name.isEmpty && !description.isEmpty {
            if !updateDates {
                queryService.postRequests(parameters : ["subject_name" : name, "subject_description" : description], sufix : "subject/InsertData", completion: { (item: [Subject]?, code:Int, error: String) in
                    DispatchQueue.main.async {
                        if !error.isEmpty {
                            self.showMessage(message: error)
                        }
                        if code == 200 {
                            guard let data = item else {
                                self.showMessage(message: NSLocalizedString("Server error. Record isn't add!", comment: "Message for user"))
                                return
                            }
                            if data.count > 0 {
                                self.saveAction?(data[0])
                                self.navigationController?.popViewController(animated: true)
                                
                            } else {
                                self.showMessage(message: NSLocalizedString("Server error. Record isn't add!", comment: "Message for user"))
                            }
                        } else if code == HTTPStatusCodes.Unauthorized.rawValue {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.showMessage(message: NSLocalizedString("Duplicate data! Please, write another information", comment: "Message for user"))
                        }
                        
                    }
                })
            } else {
                queryService.postRequests(parameters : ["subject_name" : name, "subject_description" : description], sufix : "subject/update/\(subjectId)", completion: {(item: [Subject]?, code:Int, error: String) in
                    DispatchQueue.main.async {
                        if !error.isEmpty {
                            self.showMessage(message: error)
                        }
                        if code == 200 {
                            guard let data = item else {
                                self.showMessage(message: NSLocalizedString("Server error. Record isn't change!", comment: "Message for user"))
                                return
                            }
                            if data.count > 0 {
                                self.saveAction?(data[0])
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.showMessage(message: NSLocalizedString("Server error. Record isn't add!", comment: "Message for user"))
                            }
                            
                        } else if code == HTTPStatusCodes.Unauthorized.rawValue {
                            self.navigationController?.popViewController(animated: true)
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
        if !updateDates {
            navigationItem.title = "Add new item"
        } else {
            navigationItem.title = "Update record"
        }
        subjectDescriptionTextField.layer.cornerRadius = 5
        subjectDescriptionTextField.layer.borderWidth = 1
        subjectDescriptionTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
