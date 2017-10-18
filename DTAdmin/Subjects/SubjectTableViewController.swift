//
//  SubjectTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController {

    var records = [Records]()
    
    let queryService = QueryService()
    
    var filteredData = [Records]()
    
    var inSearchMode = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRecords()
        // searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name","Description"]
        searchBar.selectedScopeButtonIndex = 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            inSearchMode = true
            switch  searchBar.selectedScopeButtonIndex {
            case 0:
                filteredData = records.filter{$0.name.contains(searchBar.text!)}
            case 1:
                filteredData = records.filter{$0.description.contains(searchBar.text!)}
                //            case 2:
            //                filteredData = records.filter{$0.id.contains(searchBar.text!)}
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
        // Dispose of any resources that can be recreated.
    }
    
    private func showRecords() {
        Records.getRecords(sufix: "getRecords", completion: { (results:[Records]?) in
            if let subjectData = results {
                self.records = subjectData
                self.records.sort { (rec1, rec2) -> Bool in
                    return rec1.name < rec2.name
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func updateRecords(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if inSearchMode {
            return filteredData.count
        }
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if inSearchMode {
            cell.textLabel?.text = filteredData[indexPath.row].name
            cell.detailTextLabel?.text = filteredData[indexPath.row].description
        } else {
            cell.textLabel?.text = records[indexPath.row].name
            cell.detailTextLabel?.text = records[indexPath.row].description
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = records[indexPath.row].id
            print(item)
            queryService.deleteReguest(sufix: "subject/del/\(item)")
            records.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second") as? AddNewRecordViewController
        {
            vc.subjectId = records[indexPath.row].id
            vc.updateDates = true
            vc.name = records[indexPath.row].name
            vc.desc = records[indexPath.row].description
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
