//
//  TestsViewController.swift
//  DTAdmin
//
//  Created by Anastasia Kinelska on 11/2/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestsViewController: ParentViewController {
    
    var cookie: HTTPCookie?
    var testsList: [TestStructure]?
    var subjectId: String?
    var subjectName: String?
        
       
    @IBOutlet weak var testsTableView: UITableView!
    
    @IBAction func showNewTestController(_ sender: UIBarButtonItem) {
        guard let newTestViewController = UIStoryboard(name: "Test", bundle: nil).instantiateViewController(withIdentifier: "NewTestViewController") as? NewTestViewController else  { return }
        newTestViewController.resultModification = { test in
            self.testsList?.append(test)
                self.testsTableView.reloadData()
        }
        self.navigationController?.pushViewController(newTestViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        self.testsTableView.reloadData()
    }
    
    func update() {
        guard let id = subjectId else { return }
        DataManager.shared.getTest(bySubject: id) { (tests, error) in
            self.testsList = tests
        self.testsTableView.reloadData()
        }
    }
}

extension TestsViewController: UITableViewDelegate {
}
  
extension TestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testsList != nil ? testsList!.count : 0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as? TestCell else {
            fatalError("The dequeued cell is not an instance of TestCell.")
        }
        cell.testName?.text = testsList![indexPath.row].name
        cell.timeForTest?.text = testsList![indexPath.row].timeForTest
        cell.attempts?.text = testsList![indexPath.row].attempts
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteOpt = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let test = self.testsList?[indexPath.row] else { return }
            DataManager.shared.deleteEntity(byId: test.id!, typeEntity: .test, completionHandler: { (status, error) in
                guard let error = error else {
                    self.testsTableView.beginUpdates()
                    self.testsList?.remove(at: indexPath.row)
                    self.testsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    self.testsTableView.endUpdates()
                    return
                }
                self.showAllert(error: error, completionHandler: nil)
            })
        }
        deleteOpt.backgroundColor = UIColor.red
        return [deleteOpt]
    }
    
}
    
    
    

