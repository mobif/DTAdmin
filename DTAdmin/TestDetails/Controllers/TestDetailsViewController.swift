//
//  TestDetailsViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/6/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailsViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dataModel = DataModel.dataModel
    var testId: String?
    var maxTasks: String?
    @IBOutlet weak var testDetailsTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Test details", comment: "title of TestDetailsViewController")
        guard let id = testId else { return }
        dataModel.id = id
        if let maxTasks = maxTasks {
            dataModel.max = Int(maxTasks)
        }
        dataModel.detailArray.removeAll()
        getTestDetails()
    }
    
    func getTestDetails() {
        DataManager.shared.getTestDetails(byTest: dataModel.id) { (details, error) in
            if error == nil, let testDetails = details {
                self.dataModel.testDetailArray = testDetails
                self.testDetailsTableView.reloadData()
            } else {
                guard let error = error else {
                    self.showWarningMsg(NSLocalizedString("Incorect type data", comment: "Incorect type data"))
                    return
                }
                self.showAllert(error: error, completionHandler: nil)
                if error.code == HTTPStatusCodes.Unauthorized.rawValue {
                    StoreHelper.logout()
                    self.showLoginScreen()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.tintColor = UIColor.white
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28))
        segmentedControl.insertSegment(withTitle: NSLocalizedString(TestDetails.id.rawValue,
            comment: "header for id in table"), at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: NSLocalizedString(TestDetails.testId.rawValue,
            comment: "header for test id in table"), at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: NSLocalizedString(TestDetails.level.rawValue,
            comment: "header for test level in table"), at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: NSLocalizedString(TestDetails.tasks.rawValue,
            comment: "header for test task in table"), at: 3, animated: false)
        segmentedControl.insertSegment(withTitle: NSLocalizedString(TestDetails.rate.rawValue,
            comment: "header for test rate in table"), at: 4, animated: false)
        segmentedControl.insertSegment(withTitle: "", at: 5, animated: false)
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
        let edit = UITableViewRowAction(style: .normal, title: NSLocalizedString("Edit", comment: "title for editing"),
                handler: { action, indexPath in
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
        let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete",
            comment: "title for deleting"), handler: { action, indexPath in
                let alert = UIAlertController(title: NSLocalizedString("WARNING", comment: "title for alert"),
                    message: NSLocalizedString("Do you want to delete this test detail?", comment: "message for alert"),
                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "title for ok key"),
                style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
            guard let id = self.dataModel.testDetailArray[indexPath.row].id else { return }
                if indexPath.row < self.dataModel.testDetailArray.count {
                    DataManager.shared.deleteEntity(byId: id, typeEntity: Entities.testDetail) { (deleted, error) in
                        if let error = error {
                            self.showAllert(error: error, completionHandler: nil)
                        } else {
                            self.dataModel.testDetailArray.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .top)
                            self.testDetailsTableView.reloadData()
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "title for cancel key"),
                                          style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        })
        return [delete, edit]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let testDetailInfoViewController = UIStoryboard(name: "TestDetails",
            bundle: nil).instantiateViewController(withIdentifier: "TestDetailInfoViewController")
                as? TestDetailInfoViewController else  { return }
        testDetailInfoViewController.testDetailInstance = self.dataModel.testDetailArray[indexPath.row]
        self.navigationController?.pushViewController(testDetailInfoViewController, animated: true)
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        dataModel.currentDataForSelecting()
        if let max = dataModel.max, dataModel.taskArrayForFiltering.reduce(0, +) >= max {
            let message = NSLocalizedString("Sum of tasks for the test can't be more then ",
                comment: "Sum of tasks should be from 1 to max")
            self.showWarningMsg(message + "\(max)")
        } else {
            guard let getTestDetailsViewController = UIStoryboard(name: "TestDetails",
                bundle: nil).instantiateViewController(withIdentifier: "GetTestDetailsViewController")
                    as? GetTestDetailsViewController else { return }
            getTestDetailsViewController.resultModification = { newTestDetail in
                self.dataModel.testDetailArray.append(newTestDetail)
                self.testDetailsTableView.reloadData()
            }
            self.navigationController?.pushViewController(getTestDetailsViewController, animated: true)
        }
    }
    
    
}
