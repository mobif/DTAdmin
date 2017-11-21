 //
 //  TestDetailCreateUpdateViewController.swift
 //  DTAdmin
 //
 //  Created by ITA student on 11/8/17.
 //  Copyright © 2017 if-ios-077. All rights reserved.
 //
 
 import UIKit
 
 class TestDetailCreateUpdateViewController: UIViewController, PickerDelegate {
    
    var dataModel = DataModel.dataModel
    var testDetailForSave: TestDetailStructure?
    var resultModification: ((TestDetailStructure) -> ())?
    var canEdit = Bool()
    var idForEditing = String()
    var id = "3"
    var maxTask = Int()

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
        let levels = dataModel.getFilteredArrayForLevels(firstArray: dataModel.createArray(max: dataModel.max),
                                                         secondArray: dataModel.levelArrayForFiltering)
        self.testLevelTextField.dropDownData = levels
        self.testLevelTextField.tag = 0
        if dataModel.taskArrayForFiltering.reduce(0, +) == dataModel.max {
            guard let task = testDetailsInstance?.tasks, let taskInt = Int(task) else { return }
            if taskInt == 1 {
                maxTask = 1
                self.taskTestTextField.isEnabled = false
                self.taskTestTextField.alpha = 0.5
            } else {
                maxTask = taskInt - 1
            }
        } else {
            let task = dataModel.max - dataModel.taskArrayForFiltering.reduce(0, +)
            maxTask = task
        }
        self.taskTestTextField.dropDownData = dataModel.createArray(max: maxTask)
        self.taskTestTextField.tag = 1
        self.rateTestTextField.dropDownData = dataModel.createArray(max: dataModel.max)
        self.rateTestTextField.tag = 2
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
        guard let level = testLevelTextField.text,
            let task = taskTestTextField.text,
            let rate = rateTestTextField.text else { return false }
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
            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled",
                                             comment: "All fields have to be filled"))
        }
    }
    
    func updateTestDetail() {
        if prepareForRequest() {
            guard let testDetailForSave = testDetailForSave else { return }
            DataManager.shared.updateEntity(byId: idForEditing,
                                            entity: testDetailForSave,
                                            typeEntity: .testDetail) { (error) in
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
            showWarningMsg(NSLocalizedString("Incorrect data. All fields have to be filled",
                                             comment: "All fields have to be filled"))
        }
    }

    
    
 }
