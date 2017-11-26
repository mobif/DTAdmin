//
//  TestDetailsViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/6/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dataModel = DataModel.dataModel
    var id = "3"
    @IBOutlet weak var testDetailsTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test details"
        getTestDetails()
    }
    
    func getTestDetails() {
        DataManager.shared.getTestDetails(byTest: self.id) { (details, error) in
            if error == nil, let testDetails = details {
                self.dataModel.testDetailArray = testDetails
                self.testDetailsTableView.reloadData()
            } else {
                self.showWarningMsg(error ?? NSLocalizedString("Incorect type data", comment: "Incorect type data"))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.tintColor = UIColor.white
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28))
        segmentedControl.insertSegment(withTitle: "id", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "test id", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "level", at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: "task", at: 3, animated: false)
        segmentedControl.insertSegment(withTitle: "rate", at: 4, animated: false)
        view.addSubview(segmentedControl)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.testDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = tableView.dequeueReusableCell(withIdentifier: "testDetailsCell",
                                                          for: indexPath) as? TestDetailsTableViewCell
        guard let cell = prototypeCell else { return UITableViewCell() }
        let array = dataModel.testDetailArray[indexPath.row]
        cell.testDetailId.text = array.id
        cell.testDetailTestId.text = array.testId
        cell.testDetailLevel.text = array.level
        cell.testDetailTasks.text = array.tasks
        cell.testDetailRate.text = array.rate
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: { action, indexPath in
            guard let getTestDetailsViewController = UIStoryboard(name: "TestDetails",
            bundle: nil).instantiateViewController(withIdentifier: "GetTestDetailsViewController")
            as? GetTestDetailsViewController else { return }
            getTestDetailsViewController.testDetailsInstance = self.dataModel.testDetailArray[indexPath.row]
            getTestDetailsViewController.canEdit = true
            getTestDetailsViewController.resultModification = { updateResult in
                self.dataModel.testDetailArray[indexPath.row] = updateResult
                self.testDetailsTableView.reloadData()
            }
            self.navigationController?.pushViewController(getTestDetailsViewController, animated: true)
        })
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { action, indexPath in
            let alert = UIAlertController(title: "WARNING", message: "Do you want to delete this test detail?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                guard let id = self.dataModel.testDetailArray[indexPath.row].id else { return }
                if indexPath.row < self.dataModel.testDetailArray.count {
                    DataManager.shared.deleteEntity(byId: id, typeEntity: Entities.testDetail) { (deleted, error) in
                        if let error = error {
                            self.showWarningMsg(error)
                        } else {
                            self.dataModel.testDetailArray.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .top)
                            self.testDetailsTableView.reloadData()
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        })
        return [delete, edit]
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        dataModel.currentDataForSelecting()
        if dataModel.taskArrayForFiltering.reduce(0, +) >= dataModel.max {
            self.showWarningMsg(NSLocalizedString("Sum of tasks for the test can't be more then \(dataModel.max)",
                                                  comment: "Sum of tasks should be from 1 to \(dataModel.max)"))
        } else {
            guard let getTestDetailsViewController = UIStoryboard(name: "TestDetails",
                                                                  bundle: nil).instantiateViewController(
                withIdentifier: "GetTestDetailsViewController") as? GetTestDetailsViewController else { return }
            self.navigationController?.pushViewController(getTestDetailsViewController, animated: true)
            getTestDetailsViewController.resultModification = { newTestDetail in
                self.dataModel.testDetailArray.append(newTestDetail)
                self.testDetailsTableView.reloadData()
            }
        }
    }
    
    /* - - - LogIn for testing - - - */
    @IBAction func loginButtonTapped(_ sender: Any) {
        //test data
        let loginText = "admin"
        let passwordText = "dtapi_admin"
        
        CommonNetworkManager.shared().logIn(username: loginText, password: passwordText) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                StoreHelper.saveUser(user: user)
                print("user is logged")
            }
        }
        
    }
    
}
