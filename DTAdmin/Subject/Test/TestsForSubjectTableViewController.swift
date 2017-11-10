//
//  TestsForSubjectTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestsForSubjectTableViewController: UITableViewController, TestTableViewCellDelegate {
    
    func didTapShowTestDetail(id: String) {
        //add seque to show test detail
    }
    
    func didTapShowQuestions(id: String) {
        guard let wayToShowQuestions = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "QuestionTableView") as? QuestionsTableViewController else { return }
        wayToShowQuestions.testId = id
        self.navigationController?.pushViewController(wayToShowQuestions, animated: true)
    }
    
    var test = [TestStructure]()
    var subjectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Subject tests"
        guard let id = subjectId else { return }
        print(id)
        showTests(id: id)
    }
    
    @IBAction func addTest(_ sender: UIBarButtonItem) {
        //add new test
    }
    
    func showTests(id: String) {
        DataManager.shared.getTest(bySubject: id) { (tests, error) in
            if error == nil {
                guard let tests = tests else { return }
                self.test = tests
                self.tableView.reloadData()
            } else {
                self.showMessage(message: error ?? "Incorect type data")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! TestTableViewCell
        cell.setTest(test: test[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {_,_ in
            //delete test record
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") {_,_ in
            //update test record
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    
}

