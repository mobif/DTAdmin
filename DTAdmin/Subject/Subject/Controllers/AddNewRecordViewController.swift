//
//  AddNewRecordViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewRecordViewController: ParentViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !updateDates {
            self.navigationItem.title = NSLocalizedString("Add new item",
                                                          comment: "Title for AddNewRecordViewController")
        } else {
            self.navigationItem.title = NSLocalizedString("Update record",
                                                          comment: "Title for AddNewRecordViewController")
        }
    }
    
    @IBAction func saveNewRecord(_ sender: UIButton) {
        if !updateDates {
            saveNewSubject()
            
        } else {
            updateSubject()
        }
    }
    
    private func saveNewSubject() {
        if prepareForSave(){
            guard let subjectForSave = subjectForSave else { return }
            DataManager.shared.insertEntity(entity: subjectForSave, typeEntity: .subject) { (subjectResult, error) in
                if let errorMessage = error {
                    self.showAllert(error: errorMessage, completionHandler: nil)
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

    private func updateSubject() {
        if prepareForSave(){
            guard let subjectIdUnwrap = subjectId else { return }
            guard let subjectForSave = subjectForSave else { return }
            DataManager.shared.updateEntity(byId: subjectIdUnwrap, entity: subjectForSave, typeEntity: .subject) {
                    error in
                if let errorMessage = error {
                    self.showAllert(error: errorMessage, completionHandler: nil)
                } else {
                    if let resultModification = self.resultModification {
                        resultModification(subjectForSave)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func prepareForSave() -> Bool {
        guard let name = subjectNameTextField.text,
            let description = subjectDescriptionTextField.text else { return false }
        
        if (name.count > minCountOfText) && (description.count > minCountOfText) {
            let dictionary: [String: Any] = ["subject_name": name, "subject_description": description]
            self.subjectForSave = SubjectStructure(dictionary: dictionary)
            return true
        } else {
            showWarningMsg(NSLocalizedString("Entered incorect data",
                                             comment: "All fields have to be filled correctly"))
            return false
        }
    }
    
}
