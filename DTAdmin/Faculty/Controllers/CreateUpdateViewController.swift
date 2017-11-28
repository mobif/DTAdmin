//
//  CreateUpdateViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/28/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class CreateUpdateViewController: UIViewController {

    var facultyForSave: FacultyStructure?
    var resultModification: ((FacultyStructure) -> ())?
    var canEdit = Bool()
    var idForEditing = String()
//    @IBOutlet weak var specialityCodeTextField: UITextField!
//    @IBOutlet weak var specialityNameTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var facultyInstance: FacultyStructure? {
        didSet {
            self.view.layoutIfNeeded()
//            specialityNameTextField.text = specialityInstance?.name
//            specialityCodeTextField.text = specialityInstance?.code
            DispatchQueue.main.async {
                if self.canEdit {
                    self.title = NSLocalizedString("Editing", comment: "title of SpecialityCreateUpdateViewController for editing")
                    self.createButton.titleLabel?.text = "Save"
                    guard let facultyId = self.facultyInstance?.id else { return }
                    self.idForEditing = facultyId
                } else {
                    self.title = NSLocalizedString("New speciality", comment: "title of SpecialityCreateUpdateViewController")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /**
     This function get data from text fields for creation new speciality item.
     - Precondition: All text fields have to have its property value.
     - Postcondition: Speciality item is prepared to request to API.
     - Returns: This function returns true - when all text fields are filled or false - when empty
     */
//    func prepareForRequest() -> Bool {
//        guard let code = specialityCodeTextField.text, let name = specialityNameTextField.text else { return false }
//        if !code.isEmpty && !name.isEmpty {
//            let dictionary: [String : Any] = ["speciality_code": code, "speciality_name": name]
//            self.specialityForSave = SpecialityStructure(dictionary: dictionary)
//            return true
//        } else {
//            return false
//        }
//    }
//
//    @IBAction func CreateSpecialityButton(_ sender: Any) {
//        !canEdit ? createSpeciality() : updateSpeciality()
//    }
//
//    func createSpeciality() {
//        if prepareForRequest() {
//            guard let specialityForSave = specialityForSave else { return }
//            DataManager.shared.insertEntity(entity: specialityForSave, typeEntity: .speciality) { (result, error) in
//                if let error = error {
//                    self.showWarningMsg(error.info)
//                    return
//                } else {
//                    guard let result = result as? [[String : Any]] else { return }
//                    guard let firstResult = result.first else { return }
//                    guard let specialityResult = SpecialityStructure(dictionary: firstResult) else { return }
//                    if let resultModification = self.resultModification {
//                        resultModification(specialityResult)
//                    }
//                }
//            }
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled",
//                                             comment: "All fields have to be filled"))
//        }
//    }
//
//    func updateSpeciality() {
//        if prepareForRequest() {
//            guard let specialityForSave = specialityForSave else { return }
//            DataManager.shared.updateEntity(byId: idForEditing, entity: specialityForSave,
//                                            typeEntity: .speciality) { (error) in
//                                                if let error = error {
//                                                    self.showWarningMsg(error.info)
//                                                    return
//                                                } else {
//                                                    if let resultModification = self.resultModification {
//                                                        specialityForSave.id = self.idForEditing
//                                                        resultModification(specialityForSave)
//                                                    }
//                                                }
//            }
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled",
//                                             comment: "All fields have to be filled"))
//        }
//    }


}
