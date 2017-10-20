//
//  SubjectTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController, UISearchBarDelegate {

    var records = [Records]()
    let queryService = QueryService()
    var filteredData = [Records]()
    var inSearchMode = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Subjects"
        showRecords()
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name", "Description"]
        searchBar.selectedScopeButtonIndex = 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            inSearchMode = true
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                filteredData = records.filter{$0.name.contains(searchBar.text!)}
            case 1:
                filteredData = records.filter{$0.description.contains(searchBar.text!)}
            default:
                print("No match")
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showRecords()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showRecords() {
        Records.getRecords(sufix: "getRecords", completion: { (results:[Records]?, statusCode: Int?) in
            if let subjectData = results, let code = statusCode {
                self.records = subjectData
                self.records.sort { return $0.name < $1.name }
                DispatchQueue.main.async {
                    if code == 200 {
                        self.tableView.reloadData()
                    } else {
                        self.showMessage(message: NSLocalizedString("Bad signal", comment: "Information for user"))
                    }
                }
            }
        })
    }
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredData.count
        } else { return records.count }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cellData = records[indexPath.row]
        if inSearchMode {
            cellData = filteredData[indexPath.row]
        }
        cell.textLabel?.text = cellData.name
        cell.detailTextLabel?.text = cellData.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let item = self.records[indexPath.row].id
            print(item)
            self.queryService.deleteReguest(sufix: "subject/del/\(item)")
            self.records.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            if let wayToAddNewRecord = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewSubject") as? AddNewRecordViewController
            {
                wayToAddNewRecord.subjectId = self.records[indexPath.row].id
                wayToAddNewRecord.updateDates = true
                wayToAddNewRecord.name = self.records[indexPath.row].name
                wayToAddNewRecord.desc = self.records[indexPath.row].description
                self.navigationController?.pushViewController(wayToAddNewRecord, animated: true)
            }
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    
    // MARK: Show TestsViewController
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wayToShowTests = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "_") as? _
        {
            wayToShowTests._ = records
            self.navigationController?.pushViewController(wayToShowTests, animated: true)
        }
    }*/
    
}