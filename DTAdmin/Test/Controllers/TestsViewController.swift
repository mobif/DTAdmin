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
    
    var subjectId: String?
    var subjectName: String? {
        didSet {
        }
    }
    
    @IBOutlet weak var testsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        self.testsTableView.reloadData()
    }
    
    func update() {
//        DataManager.shared.getList(byEntity: .Test) { (tests, error) in
//            guard let tests = tests as? [TestStructure] else {
//                print(error)
//                return
//            }
//            self.testsList = tests
//            self.testsTableView.reloadData()
//        }
        
        DataManager.shared.getTest(bySubject: "2") { (tests, error) in
            guard let tests = tests as? [TestStructure] else {
                print(error)
                return
            }
            self.testsList = tests
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
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        guard let instance = testsList?[indexPath.row] else { return nil }
//        guard let id = instance.id else {
//            return nil
//        }
//        let delete = UITableViewRowAction(style: .destructive, title: "Del") { action, index in
//            DataManager.shared.deleteEntity(byId: id, typeEntity: .Test, completionHandler: <#T##(Any?, String?) -> ()#>)
//
//            deleteTest(id: id, completionHandler: { (isComplete) in
//                if isComplete {
//                    self.testsList?.remove(at: indexPath.row)
//                    self.testsTableView.reloadData()
//                } else {
//                    let alert = UIAlertController(title: "Alert", message: "Something went wrong with deleting this entity", preferredStyle: UIAlertControllerStyle.alert)
//                    self.present(alert, animated: true, completion: nil)
//
//                }
//            })
//        }
//        return [delete]
//    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteOpt = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            guard let test = self.testsList?[indexPath.row] else { return }
            DataManager.shared.deleteEntity(byId: test.id!, typeEntity: .Test, completionHandler: { (status, error) in
                guard let error = error else {
                    self.testsTableView.beginUpdates()
                    self.testsList?.remove(at: indexPath.row)
                    self.testsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    self.testsTableView.endUpdates()
                    return
                }
                self.showWarningMsg(NSLocalizedString(error, comment: "Error alert after failed test delete"))
            })
        }
        
        deleteOpt.backgroundColor = UIColor.red
        return [deleteOpt]
    }
    
}
    
    
    

