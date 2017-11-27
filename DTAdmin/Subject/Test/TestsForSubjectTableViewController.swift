//
//  TestsForSubjectTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestsForSubjectTableViewController: UITableViewController {
    
    var test = [TestStructure]()
    var subjectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Subject tests",
                                                      comment: "Title for TestsForSubjectTableViewController")
        
        startActivityIndicator()
        showTests()
    }
    
    @IBAction func addTest(_ sender: UIBarButtonItem) {
        let groupStoryboard = UIStoryboard.stoyboard(by: .test)
        guard let testViewController = groupStoryboard.instantiateViewController(
            withIdentifier: "newTestViewController") as? NewTestViewController else { return }
        testViewController.subjectId = self.subjectId
        testViewController.resultModification = { test in
            self.test.append(test)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(testViewController, animated: true)
    }
    
    private func showTests() {
        guard let id = subjectId else { return }
        DataManager.shared.getTest(bySubject: id) { (tests, error) in
            self.stopActivityIndicator()
            if error == nil {
                guard let tests = tests else { return }
                self.test = tests
                self.tableView.reloadData()
            } else {
                self.showMessage(message: error ?? NSLocalizedString("Incorect type data",
                                                                     comment: "Message for user about incorect data"))
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! TestTableViewCell
        cell.setTest(test: test[indexPath.row])
        cell.delegate = self
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) ->
    [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive,
                                          title: NSLocalizedString("Delete", comment: "Swipe button title")) {_,_ in
            //delete test record
        }
        let update = UITableViewRowAction(style: .normal,
                                          title: NSLocalizedString("Update", comment: "Swipe button title")) {_,_ in
            //update test record
        }
        delete.backgroundColor = UIColor.red
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animatedCell(for: cell)
    }
    
}

// MARK: - TestTableViewCellDelegate
extension TestsForSubjectTableViewController: TestTableViewCellDelegate {

    func didTapShowTestDetail(for id: String) {
        //add seque to show test detail
    }

    func didTapShowQuestions(for id: String) {
        guard let questionsTableViewController = UIStoryboard(name: "Subjects",
                                                              bundle: nil).instantiateViewController(withIdentifier:
                                                                "QuestionTableView") as? QuestionsTableViewController
            else { return }
        questionsTableViewController.testId = id
        self.navigationController?.pushViewController(questionsTableViewController, animated: true)
    }
}
