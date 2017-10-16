//
//  GroupsTableViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    var groupList = [GroupStructure]()
    var selecectedGroup: ((GroupStructure) -> ())?
    var titleViewController:String?
    @IBOutlet var groupTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = RequestManager<GroupStructure>()
        manager.getEntityList(byStructure: Entities.Group, returnResults: { (groups, error) in
            if error == nil,
                groups != nil{
                self.groupList = groups!
            }
            self.groupTable.reloadData()
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        cell.name.text = groupList[indexPath.row].group_name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedInstance = groupList[indexPath.row]
        guard let returnGroup = selecectedGroup else {return}
        returnGroup(selectedInstance)
        self.navigationController?.popViewController(animated: true)
    }
}
