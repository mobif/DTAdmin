//
//  TestTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/10/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol TestTableViewCellDelegate {
    /**
     Sends to the TestDetailViewController when you press ShowTestDetails button
     - Parameter id: Send test id to the next View Controller for create request and making call's to API
     */
    func didTapShowTestDetail(for id: String, maxTasks: String)
    /**
     Sends to the QuestionViewController when you press ShowQuestions button
     - Parameter id: Send test id to the next View Controller for create request and making call's to API
     */
    func didTapShowQuestions(for id: String)
}


class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var tasksTestLabel: UILabel!
    @IBOutlet weak var timeForTestLabel: UILabel!
    @IBOutlet weak var enabledLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
    
    var testItem: TestStructure?
    var delegate: TestTableViewCellDelegate?
    
    func setTest(test: TestStructure) {
        testItem = test
        testLabel.text = test.name
        
        let testTasksText = NSLocalizedString("Tasks: ", comment: "Test tasks showing")
        tasksTestLabel.text = testTasksText + test.tasks

        let timeForTestText = NSLocalizedString("Time for test: ", comment: "Time for test showing")
        timeForTestLabel.text = timeForTestText + test.timeForTest

        let falseEnabledTest = NSLocalizedString("false", comment: "False enabled")
        let trueEnabledTest = NSLocalizedString("true", comment: "True enabled")
        let enabledText = test.enabled == "0" ? falseEnabledTest : trueEnabledTest
        let enabledTestText = NSLocalizedString("Enabled: ", comment: "Enabled for test showing")
        enabledLabel.text = enabledTestText + enabledText

        let attemptsText = NSLocalizedString("Attempts: ", comment: "Attempts for test showing")
        attemptsLabel.text = attemptsText + test.attempts
    }
    
    @IBAction func showTestDetail(_ sender: UIButton) {
        guard let id = testItem?.id,
        let tasks = testItem?.tasks else { return }
        delegate?.didTapShowTestDetail(for: id, maxTasks: tasks)
    }
    
    @IBAction func showQuestion(_ sender: UIButton) {
        guard let id = testItem?.id else { return }
        delegate?.didTapShowQuestions(for: id)
    }
    
}
