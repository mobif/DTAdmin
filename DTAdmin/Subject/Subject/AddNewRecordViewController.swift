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
    var subjectId: String?
    
    var resultModification: ((SubjectStructure) -> ())?
    var subjectForSave: SubjectStructure?
    
    var subject: SubjectStructure? {
        didSet {
            guard let subject = subject else { return }
            self.view.layoutIfNeeded()
            self.subjectNameTextField.text = subject.name
            self.subjectDescriptionTextField.text = subject.description
        }
    }
    
    @IBAction func saveNewRecord(_ sender: UIButton) {
        if !updateDates {
            saveNewSubject()
            
        } else {
            updateSubject()
        }
    }
    
    func saveNewSubject() {
        if prepareForSave(){
            guard let subjectForSave = subjectForSave else { return }
            DataManager.shared.insertEntity(entity: subjectForSave, typeEntity: .subject) { (subjectResult, error) in
                if let error = error {
                    self.showWarningMsg(error)
                } else {
                    guard let result = subjectResult as? [[String : Any]] else { return }
                    guard let resultFirst = result.first else { return }
                    guard let subjectResult = SubjectStructure(dictionary: resultFirst) else { return }
                    if let resultModification = self.resultModification {
                        resultModification(subjectResult)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateSubject() {
        if prepareForSave(){
            guard let subjectIdUnwrap = subjectId else { return }
            guard let subjectForSave = subjectForSave else { return }
            DataManager.shared.updateEntity(byId: subjectIdUnwrap, entity: subjectForSave, typeEntity: .subject) { error in
                if let error = error {
                    self.showWarningMsg(error)
                } else {
                    if let resultModification = self.resultModification {
                        resultModification(subjectForSave)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func prepareForSave() -> Bool {
        guard let name = subjectNameTextField.text,
            let description = subjectDescriptionTextField.text else { return false }
        if (name.count > 2) && (description.count > 2) {
            let dictionary: [String: Any] = ["subject_name": name, "subject_description": description]
            self.subjectForSave = SubjectStructure(dictionary: dictionary)
        } else {
            showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = updateDates ? "Update record" : "Add new item"
        subjectDescriptionTextField.layer.cornerRadius = 5
        subjectDescriptionTextField.layer.borderWidth = 1
        subjectDescriptionTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
