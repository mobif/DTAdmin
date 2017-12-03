//
//  CreateUpdateViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/28/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class CreateUpdateViewController: ParentViewController, UITextFieldDelegate {

    var facultyForSave: FacultyStructure?
    var resultModification: ((FacultyStructure) -> ())?
    var canEdit = Bool()
    var idForEditing = String()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var facultyInstance: FacultyStructure? {
        didSet {
            self.view.layoutIfNeeded()
            nameTextField.text = facultyInstance?.name
            descriptionTextField.text = facultyInstance?.description
            DispatchQueue.main.async {
                if self.canEdit {
                    self.title = NSLocalizedString("Editing", comment: "title of CreateUpdateViewController for editing")
                    self.createButton.titleLabel?.text = "Save"
                    guard let facultyId = self.facultyInstance?.id else { return }
                    self.idForEditing = facultyId
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("New faculty", comment: "title of CreateUpdateViewController")
    }
    
    /**
     This function get data from text fields for creation new faculty item.
     - Precondition: All text fields have to have its property value.
     - Postcondition: Faculty item is prepared to request to API.
     - Returns: This function returns true - when all text fields are filled or false - when empty
     */
    func prepareForRequest() -> Bool {
        guard let name = nameTextField.text, let description = descriptionTextField.text else { return false }
        if !name.isEmpty && !description.isEmpty {
            let dictionary: [String : Any] = [FacultyDetails.nameForDictionary.rawValue: name,
                                              FacultyDetails.descriptionForDictionary.rawValue: description]
            self.facultyForSave = FacultyStructure(dictionary: dictionary)
            return true
        } else {
            return false
        }
    }

    @IBAction func CreateSpecialityButton(_ sender: Any) {
        !canEdit ? createFaculty() : updateFaculty()
    }

    func createFaculty() {
        if prepareForRequest() {
            guard let facultyForSave = facultyForSave else { return }
            DataManager.shared.insertEntity(entity: facultyForSave, typeEntity: .faculty) { (result, error) in
                if let error = error {
                    self.showWarningMsg(error.info)
                    return
                } else {
                    guard let result = result as? [[String : Any]] else { return }
                    guard let firstResult = result.first else { return }
                    guard let facultyResult = FacultyStructure(dictionary: firstResult) else { return }
                    if let resultModification = self.resultModification {
                        resultModification(facultyResult)
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled",
                                             comment: "All fields have to be filled"))
        }
    }

    func updateFaculty() {
        if prepareForRequest() {
            guard var facultyResult = facultyForSave else { return }
            DataManager.shared.updateEntity(byId: idForEditing, entity: facultyResult,
                                            typeEntity: .faculty) { (error) in
                                                if let error = error {
                                                    self.showWarningMsg(error.info)
                                                    return
                                                } else {
                                                    if let resultModification = self.resultModification {
                                                        facultyResult.id = self.idForEditing
                                                        resultModification(facultyResult)
                                                    }
                                                }
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled",
                                             comment: "All fields have to be filled"))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
