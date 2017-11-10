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
        self.navigationItem.title = "Subject tests"
        guard let id = subjectId else { return }
        print(id)
        showTests(id: id)
    }
    
    @IBAction func addTest(_ sender: UIBarButtonItem) {
        
        let groupStoryboard = UIStoryboard.stoyboard(by: .test)
        guard let testViewController = groupStoryboard.instantiateViewController(withIdentifier: "newTestViewController") as? NewTestViewController else { return }
        testViewController.subjectId = self.subjectId
        testViewController.resultModification = { test in
            self.test.append(test)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(testViewController, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1). " + test[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Nastia's method
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                        let testToDelete = self.test[indexPath.row]
                        DataManager.shared.deleteEntity(byId: testToDelete.id!, typeEntity: .test, completionHandler: { (status, error) in
                            guard let error = error else {
                                self.tableView.beginUpdates()
                                self.test.remove(at: indexPath.row)
                                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                                self.tableView.endUpdates()
                                return
                            }
                            self.showWarningMsg(NSLocalizedString(error, comment: "Error alert after failed test delete"))
                        })
                    }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
                guard let wayToAddNewTest = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "NewTestViewController") as? NewTestViewController else { return }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wayToShowTestInfo = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "showTestInfo") as? ShowTestInfoViewController else { return }
        wayToShowTestInfo.test = self.test[indexPath.row]
        self.navigationController?.pushViewController(wayToShowTestInfo, animated: true)
    }
}

