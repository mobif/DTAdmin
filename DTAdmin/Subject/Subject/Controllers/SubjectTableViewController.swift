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

class SubjectTableViewController: UITableViewController, UISearchBarDelegate, SubjectTableViewCellDelegate {
    
    var records = [SubjectStructure]()
    var filteredData = [SubjectStructure]()
    var inSearchMode = false
    var selectedSubject: ((SubjectStructure) -> ())?
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Subjects"
        showRecords()
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name", "Description"]
        searchBar.selectedScopeButtonIndex = 0
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString (string: "Pull to refresh")
        refresher.tintColor = UIColor(red: 1.0, green: 0.21, blue: 0.55, alpha: 0.5)
        refresher.addTarget(self, action: #selector(showRecords), for: .valueChanged)
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        guard let wayToAddNewRecord = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewSubject") as? AddNewRecordViewController else { return }
        wayToAddNewRecord.resultModification = { subjectReturn in
            self.records.append(subjectReturn)
            self.records.sort { return $0.name < $1.name }
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(wayToAddNewRecord, animated: true)
        
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func showRecords() {
        DataManager.shared.getList(byEntity: .subject) { (subjects, error) in
            if error == nil,
                let students = subjects as? [SubjectStructure] {
                self.records = students
                self.records.sort { return $0.name < $1.name}
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            } else {
                self.showMessage(message: NSLocalizedString(error ?? "Incorect type data", comment: "Message for user") )
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredData.count : records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubjectTableViewCell
        let cellData = inSearchMode ? filteredData[indexPath.row] : records[indexPath.row]
        cell.setSubject(subject: cellData)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let subjectId = self.records[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: subjectId, typeEntity: .subject)  { (result, error) in
                if let error = error {
                    self.showMessage(message: NSLocalizedString(error, comment: "Message for user") )
                } else {
                    self.records.remove(at: indexPath.row)
                }
                self.tableView.reloadData()
            }
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            guard let wayToAddNewRecord = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewSubject") as? AddNewRecordViewController else { return }
            wayToAddNewRecord.subjectId = self.records[indexPath.row].id
            wayToAddNewRecord.updateDates = true
            wayToAddNewRecord.subject = self.records[indexPath.row]
            wayToAddNewRecord.resultModification = { subjectResult in
                self.records[indexPath.row] = subjectResult
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(wayToAddNewRecord, animated: true)
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    
    func didTapShowTest(id: String) {
        guard let subjectTestsTableViewController = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "TestForSubjectTableViewController") as? TestsForSubjectTableViewController else { return }
        subjectTestsTableViewController.subjectId = id
        self.navigationController?.pushViewController(subjectTestsTableViewController, animated: true)
    }
    
    
    func didTapShowTimeTable(id: String) {
        let timeTableStoryboard = UIStoryboard.stoyboard(by: .timeTable)
        guard let timeTableViewController = timeTableStoryboard.instantiateViewController(withIdentifier: "TimeTableListViewController") as? TimeTableListViewController else { return }
        timeTableViewController.subjectID = Int(id)
        self.navigationController?.pushViewController(timeTableViewController, animated: true)
    }
    
}

extension UITableViewController {
    func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
