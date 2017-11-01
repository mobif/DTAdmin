//
//  TestsForSubjectTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/25/17.
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
        //add new test
    }
    
    func showTests(id: String) {
        DataManager.shared.getEntityByAnother(byId: id, typeEntity: .Test) { (tests, error) in
            if error == nil,
                let tests = tests as? [TestStructure] {
                self.test = tests
                self.tableView.reloadData()
            } else {
                self.showWarningMsg(error ?? "Incorect type data")
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
        cell.textLabel?.text = test[indexPath.row].name
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wayToShowTestInfo = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "showTestInfo") as? ShowTestInfoViewController
        {
            wayToShowTestInfo.test = self.test[indexPath.row]
            print(test[indexPath.row].id!)
            self.navigationController?.pushViewController(wayToShowTestInfo, animated: true)
        }
    }

}
