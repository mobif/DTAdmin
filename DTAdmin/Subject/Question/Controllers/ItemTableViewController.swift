//
//  ItemTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/21/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController {

    var currentArray = [String]()
    var resultModification: ((String) -> ())?

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        if let resultModification = self.resultModification {
            resultModification("")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        cell.textLabel?.text = currentArray[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if let resultModification = self.resultModification {
            resultModification(currentArray[indexPath.row])
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none

    }

}
