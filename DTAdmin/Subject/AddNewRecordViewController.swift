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
    var name: String = ""
    var desc: String = ""
    let queryService = QueryService()
    var saveAction: ((Records?) -> ())?
    var item: Records?
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveNewRecord(_ sender: UIButton) {
        guard let name = subjectNameTextField.text?.capitalized else { return }
        guard let description = subjectDescriptionTextField.text?.capitalized else { return }
        
        if !name.isEmpty && !description.isEmpty {
            if !updateDates {
                queryService.postRequests(parameters : ["subject_name" : name, "subject_description" : description], sufix : "subject/InsertData", completion: {(item: [Records]?, code:Int, error: String) in
                        DispatchQueue.main.async {
                            if code == 200 {
                                if let data = item {
                                    self.item = data[0]
                                    self.saveAction!(self.item)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            } else {
                                self.showMessage(message: NSLocalizedString("Duplicate data! Please, write another information", comment: "Message for user"))
                            }
                            if !error.isEmpty {
                                    self.showMessage(message: NSLocalizedString("Duplicate data! Please, write another information", comment: "Message for user"))
                            }
                        }
                    
                    })
            } else {
                queryService.postRequests(parameters : ["subject_name" : name, "subject_description" : description], sufix : "subject/update/\(subjectId)", completion: {(item: [Records]?, code:Int, error: String) in
                    DispatchQueue.main.async {
                        if code == 200 {
                            if let data = item {
                                self.item = data[0]
                                self.saveAction!(self.item)
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            self.showMessage(message: NSLocalizedString("Duplicate data! Please, write another information", comment: "Message for user"))
                        }
                        if !error.isEmpty {
                            self.showMessage(message: NSLocalizedString("Duplicate data! Please, write another information", comment: "Message for user"))
                        }
                    }
                })
            }
        } else {
            showMessage(message: NSLocalizedString("Please, enter all fields!", comment: "Message for user") )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !updateDates {
            navigationItem.title = "Add new item"
        } else {
            navigationItem.title = "Update record"
            subjectNameTextField.text = name
            subjectDescriptionTextField.text = desc
        }
        subjectDescriptionTextField.layer.cornerRadius = 5
        subjectDescriptionTextField.layer.borderWidth = 1
        subjectDescriptionTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
