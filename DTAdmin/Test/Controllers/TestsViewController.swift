//
//  TestsViewController.swift
//  DTAdmin
//
//  Created by Anastasia Kinelska on 11/2/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestsViewController: UIViewController {
    
    var cookie: HTTPCookie?
    var testsList = [TestStructure]()

    @IBOutlet weak var testsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.getList(byEntity: .Test) { (tests, error) in
            self.testsList = tests as! [TestStructure]
            self.testsTableView.reloadData()
        }
    }
}

extension TestsViewController: UITableViewDelegate {
}
  
extension TestsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testsList != nil ? testsList.count : 0  // ternary operator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as? TestCell else {
            fatalError("The dequeued cell is not an instance of TestCell.")
        }
        let newTestsList = testsList[indexPath.row]
        cell.testName.text = newTestsList.name
        cell.timeForTest.text = newTestsList.timeForTest
        cell.attempts.text = newTestsList.attempts
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//    }
}
    
    
    

