//
//  ShowTestInfoViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/27/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class ShowTestInfoViewController: UIViewController {

    @IBOutlet weak var testNameLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var timeForTestLabel: UILabel!
    @IBOutlet weak var enabledLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
    
    var test: TestStructure? {
        didSet {
            guard let test = test else { return }
            self.view.layoutIfNeeded()
            self.testNameLabel.text = test.name
            self.tasksLabel.text = "Tasks: " + test.tasks
            self.timeForTestLabel.text = "Time for test: " + test.timeForTest
            self.enabledLabel.text = "Enabled: " + test.enabled
            self.attemptsLabel.text = "Attemts: " + test.attempts
        }
    }
    
    @IBAction func showTestDetail(_ sender: UIButton) {
        // to show test detail
    }
    
    @IBAction func showTestQuestions(_ sender: UIButton) {
        if let wayToShowQuestions = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "QuestionTableView") as? QuestionsTableViewController
        {
            guard let test = test else { return }
            guard let testId = test.id else { return }
            wayToShowQuestions.testId = testId
            print(testId)
            self.navigationController?.pushViewController(wayToShowQuestions, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail subject test"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
