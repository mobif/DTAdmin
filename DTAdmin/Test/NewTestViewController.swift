//
//  NewTestViewController.swift
//  DTAdmin
//
//  Created by Anastasia Kinelska on 11/2/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class NewTestViewController: ParentViewController {

    var subjectId: String?
    var edit = Bool()
    private let isDisabled = NSLocalizedString("Is Disabled", comment: "Test is disabled for students ot take")
    private let isEnabled = NSLocalizedString("Is Enabled", comment: "Test is enabled for students ot take")
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var isEnabledLabel: UILabel!
    @IBOutlet weak var testNameTextField: UITextField!
    @IBOutlet weak var timeForTestTextField: UITextField!
    @IBOutlet weak var attemptsTextField: UITextField!
    @IBOutlet weak var questionsTextField: UITextField!
    
    var resultModification: ((TestStructure) -> ())?
    
    var testInstance: TestStructure? {
        didSet {
            self.view.layoutIfNeeded()
            enabledSwitch.isOn = false
            isEnabledLabel.text = isDisabled
            if testInstance?.enabled == "1" {
                enabledSwitch.isOn = true
                isEnabledLabel.text = isEnabled
            }
            testNameTextField.text = testInstance?.name
            timeForTestTextField.text = testInstance?.timeForTest
            attemptsTextField.text = testInstance?.attempts
            questionsTextField.text = testInstance?.tasks
        }
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if (sender.isOn == true) {
            isEnabledLabel.text = isEnabled
        } else {
            isEnabledLabel.text = isDisabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if edit {
            self.title = NSLocalizedString("Update test", comment: "ViewController title")
        } else {
            self.title = NSLocalizedString("New test", comment: "ViewController title")
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if testInstance == nil {
           create()
        } else {
            update()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func create() {
        guard let sample = unWrapFields() else { return }
        guard let testForSave = TestStructure(dictionary: ["test_name": sample.name,
                                                           "subject_id": sample.subjectId,
                                                           "tasks": sample.tasks,
                                                           "time_for_test": sample.timeForTest,
                                                           "enabled": sample.enabled,
                                                           "attempts": sample.attempts]) else { return }
        DataManager.shared.insertEntity(entity: testForSave, typeEntity: .test) { (entity, error) in
            if let error = error {
                self.showAllert(error: error, completionHandler: nil)
            } else {
                guard let newEntity = entity as? [[String : Any]] else {
                    self.showWarningMsg(NSLocalizedString("Incorect response structure",
                                                          comment: "New test not found in the response message"))
                    return
                }
                guard let firstElement = newEntity.first else { return }
                guard let result = TestStructure(dictionary: firstElement) else { return }
                if let resultModification = self.resultModification {
                    resultModification(result)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func update() {
        guard let sample = unWrapFields() else { return }
        
        guard let testInstance = testInstance, let testId = testInstance.id else { return }
        guard var testForSave = TestStructure(dictionary: ["test_id": testId,
                                                           "test_name": sample.name,
                                                           "subject_id": sample.subjectId,
                                                           "tasks": sample.tasks,
                                                           "time_for_test": sample.timeForTest,
                                                           "enabled": sample.enabled,
                                                           "attempts": sample.attempts]) else { return }
        DataManager.shared.updateEntity(byId: testId, entity: testForSave, typeEntity: .test) { (error) in
            if let error = error {
                self.showAllert(error: error, completionHandler: nil)
            } else {
                testForSave.id = testId
                if let resultModification = self.resultModification {
                    resultModification(testForSave)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func unWrapFields() -> (subjectId: String, name: String, tasks: String, timeForTest: String, enabled: String, attempts: String)? {
        if let name = testNameTextField.text,
            let tasks = questionsTextField.text,
            let timeForTest = timeForTestTextField.text,
            let attempts = attemptsTextField.text {
            var enabled = "0"
            if enabledSwitch.isOn {
                enabled = "1"
            }
            
            if let subjectId = testInstance?.subjectId {
                return (subjectId, name, tasks, timeForTest, enabled, attempts)
            }
            if let subjectId = self.subjectId {
                return (subjectId, name, tasks, timeForTest, enabled, attempts)
            }
        }
        return nil
    }
}
