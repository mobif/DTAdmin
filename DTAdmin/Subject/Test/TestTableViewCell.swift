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
    func didTapShowTestDetail(id: String)
    /**
     Sends to the QuestionViewController when you press ShowQuestions button
     - Parameter id: Send test id to the next View Controller for create request and making call's to API
     */
    func didTapShowQuestions(id: String)
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
        tasksTestLabel.text = NSLocalizedString("Tasks: ", comment: "Information for user") + test.tasks
        timeForTestLabel.text = NSLocalizedString("Time for test: ", comment: "Information for user") + test.timeForTest
        enabledLabel.text = NSLocalizedString("Enabled: ", comment: "Information for user") + test.enabled
        attemptsLabel.text = NSLocalizedString("Attemts: ", comment: "Information for user") + test.attempts
    }
    
    @IBAction func showTestDetail(_ sender: UIButton) {
        guard let id = testItem?.id else { return }
        delegate?.didTapShowTestDetail(id: id)
    }
    
    @IBAction func showQuestion(_ sender: UIButton) {
        guard let id = testItem?.id else { return }
        delegate?.didTapShowQuestions(id: id)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
