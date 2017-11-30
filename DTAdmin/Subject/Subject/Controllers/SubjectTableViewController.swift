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

    @IBOutlet weak var searchFooter: SearchFooter!

    var records = [SubjectStructure]()
    var filteredData = [SubjectStructure]()
    var selectedSubject: ((SubjectStructure) -> ())?
    var refresh: MyRefreshController!
    let searchController = MySearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Subjects", comment: "Title for SubjectTableViewController")
        showRecords()
        searchControllerConfigure()
        refreshControllerConfigure()
        tableView.tableFooterView = searchFooter
    }

    private func searchControllerConfigure() {
        searchController.searchResultsUpdater = self
        searchController.configure()
        navigationItem.searchController = searchController
        definesPresentationContext = true

        searchController.searchBar.scopeButtonTitles = [
            NSLocalizedString("Name", comment: "Scope title for searchController"),
            NSLocalizedString("Description", comment: "Scope title for searchController")
        ]
        searchController.searchBar.delegate = self
    }

    private func refreshControllerConfigure() {
        refresh = MyRefreshController()
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(showRecords), for: .valueChanged)
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
            self.refresh.endRefreshing()
            if errorMessage == nil,
                let subjectsRecords = subjects as? [SubjectStructure] {
                self.records = subjectsRecords
                self.records.sort { return $0.name < $1.name}
                self.tableView.reloadData()
            } else {
                self.showMessage(message: errorMessage?.message ?? NSLocalizedString("Incorect type data",
                                                                            comment: "Message for about incorect data"))
            }
        }
    }

    private func filterContentForSearchText(_ searchText: String, scope: String) {
        filteredData = records.filter({ (subject : SubjectStructure) -> Bool in

            if scope == "Description" {
                return subject.description.lowercased().contains(searchText.lowercased())
            } else {
                return subject.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredData.count, of: records.count)
            return filteredData.count
        }

        searchFooter.setNotFiltering()
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? SubjectTableViewCell else { fatalError("The dequeued cell is not an instance of MealTableViewCell.") }
        let cellData = searchController.isFiltering() ? filteredData[indexPath.row] : records[indexPath.row]
        cell.setSubject(subject: cellData)
        cell.delegate = self
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) ->
    [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive,
                                          title: NSLocalizedString("Delete",
                                                                comment: "Swipe button title")) { (action, indexPath) in
            guard let subjectId = self.records[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: subjectId, typeEntity: .subject)  { (result, error) in
                if let errorMessage = error {
                    self.showMessage(message: errorMessage.message)
                } else {
                    self.records.remove(at: indexPath.row)
                }
                self.tableView.reloadData()
            }
        }
        let update = UITableViewRowAction(style: .normal,
                                          title: NSLocalizedString("Update",
                                                                comment: "Swipe button title")) { (action, indexPath) in
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

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animatedCell(for: cell)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let messageFirstWord = NSLocalizedString("Name: ",
                                        comment: "Name of subject for alert message in accesory button tapped")
        let messageSecondWord = records[indexPath.row].name
        let messageThirdWord = NSLocalizedString("Description: ",
                              comment: "Description of subject for alert message in accesory button tapped")
        let messageFourthWord = records[indexPath.row].description
        showMessage(message: messageFirstWord + messageSecondWord + "\n" + messageThirdWord + messageFourthWord,
                    title: "Detail")
    }
}

// MARK: - UISearchResultsUpdating
extension SubjectTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText, scope: scope)
    }
}

// MARK: - UISearchBarDelegate
extension SubjectTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchBar.text else { return }
        filterContentForSearchText(searchText, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - SubjectTableViewCellDelegate
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

