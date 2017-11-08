//
//  TestDetailCreateUpdateViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailCreateUpdateViewController: UIViewController {

    var testDetailForSave: TestDetailStructure?
    var resultModification: ((TestDetailStructure) -> ())?
    var canEdit = Bool()
    var idForEditing = String()
    var id = "3"
    @IBOutlet weak var testLevelTextfield: UITextField!
    @IBOutlet weak var numberOfTaskTextField: UITextField!
    @IBOutlet weak var numberOfMarkTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var testDetailsInstance: TestDetailStructure? {
        didSet {
            self.view.layoutIfNeeded()
            testLevelTextfield.text = testDetailsInstance?.level
            numberOfTaskTextField.text = testDetailsInstance?.tasks
            numberOfMarkTextField.text = testDetailsInstance?.rate
            DispatchQueue.main.async {
                if self.canEdit {
                    self.title = "Editing"
                    self.createButton.titleLabel?.text = "Save"
                    guard let testDetailId = self.testDetailsInstance?.id else { return }
                    self.idForEditing = testDetailId
                } else {
                    self.title = "New speciality"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /* - - - building for request - - - */
    func prepareForRequest() -> Bool {
        guard let level =  testLevelTextfield.text, let task = numberOfTaskTextField.text, let rate = numberOfMarkTextField.text else { return false }
        let dictionary: [String: Any] = ["id": idForEditing, "test_id": id, "level": level, "tasks": task, "rate": rate]
        self.testDetailForSave = TestDetailStructure(dictionary: dictionary)
        return true
    }
    
    @IBAction func CreateSpecialityButton(_ sender: Any) {
        !canEdit ? createTestDetail() : updateTestDetail()
        self.navigationController?.popViewController(animated: true)
    }
    
    /* - - - create - - -  */
    func createTestDetail() {
        if prepareForRequest() {
            guard let testDetailForSave = testDetailForSave else { return }
            DataManager.shared.insertEntity(entity: testDetailForSave, typeEntity: .TestDetail) { (result, error) in
                if let error = error {
                    self.showWarningMsg(error)
                    return
                } else {
                    guard let result = result as? [[String : Any]] else { return }
                    guard let firstResult = result.first else { return }
                    guard let testDetailResult = TestDetailStructure(dictionary: firstResult) else { return }
                    if let resultModification = self.resultModification {
                        resultModification(testDetailResult)
                    }
                }
            }
        }
    }

    /* - - - update - - -  */
    func updateTestDetail() {
        if prepareForRequest() {
            guard let testDetailForSave = testDetailForSave else { return }
            DataManager.shared.updateEntity(byId: idForEditing, entity: testDetailForSave, typeEntity: .TestDetail) { (error) in
                if let error = error {
                    self.showWarningMsg(error)
                    return
                } else {
                    if let resultModification = self.resultModification {
                        resultModification(testDetailForSave)
                    }
                }
            }
        }
    }


}
