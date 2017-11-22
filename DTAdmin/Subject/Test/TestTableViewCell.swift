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
    func didTapShowTestDetail(for id: String)
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
        tasksTestLabel.text = NSLocalizedString("Tasks: ", comment: "Test tasks showing") + test.tasks
        timeForTestLabel.text = NSLocalizedString("Time for test: ",
                                                  comment: "Time for test showing") + test.timeForTest
        let enabled = test.enabled == "0" ? NSLocalizedString("false", comment: "False enabled") :
                                            NSLocalizedString("true", comment: "True enabled")
        enabledLabel.text = NSLocalizedString("Enabled: ", comment: "Enabled for test showing") + enabled
        attemptsLabel.text = NSLocalizedString("Attempts: ", comment: "Attempts for test showing") + test.attempts
    }
    
    @IBAction func showTestDetail(_ sender: UIButton) {
        guard let id = testItem?.id else { return }
        delegate?.didTapShowTestDetail(for: id)
    }
    
    @IBAction func showQuestion(_ sender: UIButton) {
        guard let id = testItem?.id else { return }
        delegate?.didTapShowQuestions(for: id)
    }
    
}
