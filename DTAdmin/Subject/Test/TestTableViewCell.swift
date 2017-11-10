//
//  TestTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/10/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol TestTableViewCellDelegate {
    
    func didTapShowTestDetail(id: String)
    func didTapShowQuestions(id: String)
}


class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var tasksTestLabel: UILabel!
    
    @IBOutlet weak var timeForTestLabel: UILabel!
    
    @IBOutlet weak var enabledLabel: UILabel!
    
    @IBOutlet weak var attemptsLabel: UILabel!
    
    var testItem: TestStructure!
    var delegate: TestTableViewCellDelegate?
    
    func setTest(test: TestStructure) {
        testItem = test
        testLabel.text = test.name
        tasksTestLabel.text = "Tasks: " + test.tasks
        timeForTestLabel.text = "Time for test: " + test.timeForTest
        enabledLabel.text = "Enabled: " + test.enabled
        attemptsLabel.text = "Attemts: " + test.attempts
    }
    
    @IBAction func showTestDetail(_ sender: UIButton) {
        guard let id = testItem.id else { return }
        delegate?.didTapShowTestDetail(id: id)
    }
    
    @IBAction func showQuestion(_ sender: UIButton) {
        guard let id = testItem.id else { return }
        delegate?.didTapShowQuestions(id: id)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
