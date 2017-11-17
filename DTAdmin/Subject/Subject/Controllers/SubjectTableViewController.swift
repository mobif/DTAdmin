//
//  SubjectTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

//
//  SubjectTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    var records = [SubjectStructure]()
    var filteredData = [SubjectStructure]()
    var inSearchMode = false
    var selectedSubject: ((SubjectStructure) -> ())?
    var searchController: UISearchController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Subjects", comment: "Title for SubjectTableViewController")
        showRecords()

        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name", "Description"]
        searchBar.selectedScopeButtonIndex = 0

        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(showRecords), for: .valueChanged)
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        guard let addNewRecordViewController = UIStoryboard(name: "Subjects",
                                                            bundle: nil).instantiateViewController(withIdentifier:
                                                                "AddNewSubject") as? AddNewRecordViewController else {
                                                                    return }
        addNewRecordViewController.resultModification = { subjectReturn in
            self.records.append(subjectReturn)
            self.records.sort { return $0.name < $1.name }
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(addNewRecordViewController, animated: true)
        
    }
    
    @objc private func showRecords() {
       startActivityIndicator()
        DataManager.shared.getList(byEntity: .subject) { (subjects, errorMessage) in
            self.stopActivityIndicator()
            if errorMessage == nil,
                let subjectsRecords = subjects as? [SubjectStructure] {
                self.records = subjectsRecords
                self.records.sort { return $0.name < $1.name}
                self.tableView.reloadData()
            } else {
                self.showMessage(message: errorMessage ?? NSLocalizedString("Incorect type data",
                                                                            comment: "Message for about incorect data"))
            }
        }
        self.refreshControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredData.count : records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? SubjectTableViewCell else { fatalError("The dequeued cell is not an instance of MealTableViewCell.") }
        let cellData = inSearchMode ? filteredData[indexPath.row] : records[indexPath.row]
        cell.setSubject(subject: cellData)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) ->
    [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let subjectId = self.records[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: subjectId, typeEntity: .subject)  { (result, errorMessage) in
                if let errorMessage = errorMessage {
                    self.showMessage(message: errorMessage)
                } else {
                    self.records.remove(at: indexPath.row)
                }
                self.tableView.reloadData()
            }
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            guard let addNewRecordViewController = UIStoryboard(name: "Subjects",
                                                                bundle: nil).instantiateViewController(withIdentifier:
                                                                    "AddNewSubject") as? AddNewRecordViewController
            else { return }
            addNewRecordViewController.subjectId = self.records[indexPath.row].id
            addNewRecordViewController.updateDates = true
            addNewRecordViewController.subject = self.records[indexPath.row]
            addNewRecordViewController.resultModification = { subjectResult in
                self.records[indexPath.row] = subjectResult
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(addNewRecordViewController, animated: true)
        }
        update.backgroundColor = UIColor.blue
        return [delete, update] 
    }

}

extension SubjectTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            inSearchMode = true
            guard let searchText = searchBar.text else { return }
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                filteredData = records.filter{$0.name.contains(searchText)}
            case 1:
                filteredData = records.filter{$0.description.contains(searchText)}
            default:
                print("No match")
            }
            tableView.reloadData()
        }
    }
}

extension SubjectTableViewController: SubjectTableViewCellDelegate {

    func didTapShowTest(for id: String) {
        guard let subjectTestsTableViewController = UIStoryboard(name: "Subjects",
                                                                 bundle: nil).instantiateViewController(withIdentifier: "TestForSubjectTableViewController") as? TestsForSubjectTableViewController else { return }
        subjectTestsTableViewController.subjectId = id
        self.navigationController?.pushViewController(subjectTestsTableViewController, animated: true)
    }

    func didTapShowTimeTable(for id: String) {
        let timeTableStoryboard = UIStoryboard.stoyboard(by: .timeTable)
        guard let timeTableViewController = timeTableStoryboard.instantiateViewController(withIdentifier:
            "TimeTableListViewController") as? TimeTableListViewController else { return }
        timeTableViewController.subjectID = Int(id)
        self.navigationController?.pushViewController(timeTableViewController, animated: true)
    }
}

