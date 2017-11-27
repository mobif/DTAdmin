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
                self.showMessage(message: error?.message ?? NSLocalizedString("Incorect type data",
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
        
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let testToDelete = self.test[indexPath.row]
            DataManager.shared.deleteEntity(byId: testToDelete.id!, typeEntity: .test, completionHandler: {
                    (status, error) in
                if error == nil {
                    self.tableView.beginUpdates()
                    self.test.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    self.tableView.endUpdates()
                    return
                } else {
                    self.showWarningMsg(error!)
                }
            })
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            guard let wayToAddNewTest = UIStoryboard.stoyboard(by: .test).instantiateViewController(withIdentifier: "newTestViewController") as? NewTestViewController else { return }
            wayToAddNewTest.edit = true
            wayToAddNewTest.testInstance = self.test[indexPath.row]
            wayToAddNewTest.resultModification = { test in
                self.test[indexPath.row] = test
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(wayToAddNewTest, animated: true)
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
