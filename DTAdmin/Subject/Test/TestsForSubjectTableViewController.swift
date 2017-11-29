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
    @IBOutlet weak var searchFooter: SearchFooter!
    var filteredData = [TestStructure]()
    var refresh: MyRefreshController!
    let searchController = MySearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Subject tests",
                                                      comment: "Title for TestsForSubjectTableViewController")
        
        startActivityIndicator()
        showTests()
        searchControllerConfigure()
        refreshControllerConfigure()
        tableView.tableFooterView = searchFooter
    }
    
    private func searchControllerConfigure() {
        searchController.searchResultsUpdater = self
        searchController.configure()
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func refreshControllerConfigure() {
        refresh = MyRefreshController()
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(showTests), for: .valueChanged)
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
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredData = test.filter({ (test : TestStructure) -> Bool in
            return test.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    @objc private func showTests() {
        guard let id = subjectId else { return }
        DataManager.shared.getTest(bySubject: id) { (tests, error) in
            if error == nil {
                guard let tests = tests else { return }
                self.test = tests
                self.tableView.reloadData()
            } else {
                self.showMessage(message: error?.message ?? NSLocalizedString("Incorect type data",
                                                                     comment: "Message for user about incorect data"))
            }
            self.stopActivityIndicator()
            self.refresh.endRefreshing()
        }
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredData.count, of: test.count)
            return filteredData.count
        }
        
        searchFooter.setNotFiltering()
        return test.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! TestTableViewCell
        let cellData = searchController.isFiltering() ? filteredData[indexPath.row] : test[indexPath.row]
        cell.setTest(test: cellData)
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
                    self.showMessage(message: error?.info ?? "")
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

// MARK: - UISearchResultsUpdating
extension TestsForSubjectTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText)
    }
}

// MARK: - TestTableViewCellDelegate
extension TestsForSubjectTableViewController: TestTableViewCellDelegate {

    func didTapShowTestDetail(for id: String, maxTasks: String) {
        guard let testDetailsViewController = UIStoryboard.stoyboard(by:
            .testDetails).instantiateViewController(withIdentifier: "TestDetailsViewController") as? TestDetailsViewController
            else { return }
        testDetailsViewController.testId = id
        testDetailsViewController.maxTasks = maxTasks
        self.navigationController?.pushViewController(testDetailsViewController, animated: true)
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
