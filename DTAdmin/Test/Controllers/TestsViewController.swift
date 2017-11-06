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
    var testsList: [TestStructure]?

//    var filteredList: [TestStructure]? {
//        return self.testsList
//    }
    
    @IBOutlet weak var testsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
        self.testsTableView.reloadData()
    }
    
    func update() {
        DataManager.shared.getList(byEntity: .Test) { (tests, error) in
            
            guard let tests = tests as? [TestStructure] else {
                print(error)
                return
            }
            self.testsList = tests as? [TestStructure]
            self.testsTableView.reloadData()
        }
    }

}


extension TestsViewController: UITableViewDelegate {
}
  
extension TestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testsList != nil ? testsList!.count : 0  // ternary operator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as? TestCell else {
            fatalError("The dequeued cell is not an instance of TestCell.")
        }
//        guard let test = testsList![indexPath.row] else {
//            print('Unwrap fail')
//            return
//        }
        cell.testName?.text = testsList![indexPath.row].name
        cell.timeForTest?.text = testsList![indexPath.row].timeForTest
        cell.attempts?.text = testsList![indexPath.row].attempts
        return cell
    }
    

}
    
    
    

