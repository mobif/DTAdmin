 //
//  TestDetailCreateUpdateViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailCreateUpdateViewController: UIViewController, PickerDelegate {
    
    var testDetailForSave: TestDetailStructure?
    var resultModification: ((TestDetailStructure) -> ())?
    var canEdit = Bool()
    var idForEditing = String()
    var doneLevelArray = [Int]()
    var doneTasksArray = [Int]()
    var id = "3"


    @IBOutlet weak var testLevelTextField: PickedTextField!
    @IBOutlet weak var taskTestTextField: PickedTextField!
    @IBOutlet weak var rateTestTextField: PickedTextField!
    @IBOutlet weak var createButton: UIButton!
    
    var testDetailsInstance: TestDetailStructure? {
        didSet {
            self.view.layoutIfNeeded()
            testLevelTextField.text = testDetailsInstance?.level
            taskTestTextField.text = testDetailsInstance?.tasks
            rateTestTextField.text = testDetailsInstance?.rate
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
        testLevelTextField.customDelegate = self
        taskTestTextField.customDelegate = self
        rateTestTextField.customDelegate = self
        
        self.testLevelTextField.dropDownData = getFilteredArrayForLevels(firstArray: createArray(max: 10), secondArray: doneLevelArray)
        self.testLevelTextField.tag = 0
        self.taskTestTextField.dropDownData = getFilteredArrayForTasks(array: createArray(max: 5))
        self.taskTestTextField.tag = 1
        self.rateTestTextField.dropDownData = createArray(max: 3)
        self.rateTestTextField.tag = 2
    }
    
    func createArray(max: Int) -> [Int] {
        var array = [Int]()
        for i in 1...max {
            array.append(i)
        }
        return array
    }
    
    func getFilteredArrayForLevels(firstArray: [Int], secondArray: [Int]) -> [Int] {
        var filtered = firstArray 
        for item in secondArray {
            if let index = filtered.index(of: item) {
                filtered.remove(at: index)
            }
        }
        return filtered
    }
    
    func getFilteredArrayForTasks(array: [Int]) -> [Int] {
        var filtered = [Int]()
        let sum = array.reduce(0, +)
        filtered.append(sum)
        return filtered
    }
    
    func pickedValue(value: Any, tag: Int) {
        if let intValue = value as? Int {
            switch tag {
            case 0:
                self.testLevelTextField.text = String(intValue)
            case 1:
                self.taskTestTextField.text = String(intValue)
            case 2:
                self.rateTestTextField.text = String(intValue)
            default:
                break
            }
        }
    }
    
    /**
     This function get data from text fields for creation new text detail item.
     - Precondition: All text fields have to have its property value.
     - Postcondition: Test detail item is prepared to request to API.
     - Returns: This function returns true - when all text fields are filled or false - when empty
     */
    func prepareForRequest() -> Bool {
        guard let level = testLevelTextField.text, let task = taskTestTextField.text, let rate = rateTestTextField.text else { return false }
        if !level.isEmpty && !task.isEmpty && !rate.isEmpty {
            let dictionary: [String: Any] = ["test_id": id, "level": level, "tasks": task, "rate": rate]
            self.testDetailForSave = TestDetailStructure(dictionary: dictionary)
            return true
        } else {
            return false
        }
    }
    
    @IBAction func CreateSpecialityButton(_ sender: Any) {
        !canEdit ? createTestDetail() : updateTestDetail()
    }
    
    func createTestDetail() {
        if prepareForRequest() {
            guard let testDetailForSave = testDetailForSave else { return }
            DataManager.shared.insertEntity(entity: testDetailForSave, typeEntity: .testDetail) { (result, error) in
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
            self.navigationController?.popViewController(animated: true)
        } else {
            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled", comment: "All fields have to be filled"))
        }
    }
    
    func updateTestDetail() {
        if prepareForRequest() {
            guard let testDetailForSave = testDetailForSave else { return }
            DataManager.shared.updateEntity(byId: idForEditing, entity: testDetailForSave, typeEntity: .testDetail) { (error) in
                if let error = error {
                    self.showWarningMsg(error)
                    return
                } else {
                    if let resultModification = self.resultModification {
                        testDetailForSave.id = self.idForEditing
                        resultModification(testDetailForSave)
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled", comment: "All fields have to be filled"))
        }
    }
    
    
}
