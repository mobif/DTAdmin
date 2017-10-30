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
    
    var test: Test? {
        didSet {
            guard let test = test else { return }
            self.view.layoutIfNeeded()
            self.testNameLabel.text = test.testName
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
            wayToShowQuestions.testId = self.test!.testId
            print(test!.testId)
            self.navigationController?.pushViewController(wayToShowQuestions, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
