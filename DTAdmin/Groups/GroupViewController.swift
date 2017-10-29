//
//  GroupViewController.swift
//  DTAdmin
//
//  Created by Admin on 19.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBAction func createNewGroup(_ sender: Any) {
        guard let createUpdateGroupViewController = getCreateUpdateGroupViewController() else { return }
        createUpdateGroupViewController.saveAction = { newGroup in
//            self.commonDataForGroups.append(newGroup)
            self.groups.append(newGroup)
        }
        navigationController?.pushViewController(createUpdateGroupViewController, animated: true)
    }
    
//    var commonDataForGroups = [Group]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.groupTableView.reloadData()
//            }
//        }
//    }
    
    var isSelectAction: Bool?
    var selectGroup: ((Group) -> ())?
    var groups = [Group]() {
        didSet {
            DispatchQueue.main.async {
                self.self.groupTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        groupTableView.delegate = self
        groupTableView.dataSource = self
//        getCommonArrayForGroups(){(result:[Group]) in
//            self.commonDataForGroups = result
//        }
        HTTPService.getAllData(entityName: "group") {
            (groupJSON:[[String:String]],groupResponce) in
            let groups = groupJSON.flatMap{Group(dictionary: $0)}
            self.groups = groups
        }
    }
    
    func getCreateUpdateGroupViewController() -> GroupCreateUpdateViewController? {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
        let creteUpdateGroupViewController = storyBoard.instantiateViewController(withIdentifier: "CreateUpdateVC") as! GroupCreateUpdateViewController
        return creteUpdateGroupViewController
    }
    
    func updateGroup(index: Int) {
        guard let createUpdateGroupViewController = getCreateUpdateGroupViewController() else { return }
        createUpdateGroupViewController.groupForUpdate = self.groups[index]
        createUpdateGroupViewController.saveAction = { updatedGroup in
            if let index = self.groups.index(where: {$0.id == updatedGroup.id}) {
                self.groups[index] = updatedGroup
            } else {
                print("wrong index for update")
            }
        }
        navigationController?.pushViewController(createUpdateGroupViewController, animated: true)
    }
    
    func showGroupDetails(group: Group) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
        let groupDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "GroupDetailsVC") as! GroupDetailsViewController
        groupDetailsViewController.group = group
        navigationController?.pushViewController(groupDetailsViewController, animated: true)
    }
    
}

//MARK: table view delegate
extension GroupViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSelectAction == nil {
            showGroupDetails(group: groups[indexPath.row])
        } else {
            let selectedGroup = self.groups[indexPath.row]
            self.selectGroup!(selectedGroup)
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: table view data source
extension GroupViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "DELETE"){(action, indexPath) in
            HTTPService.deleteData(entityName: "group", id: self.groups[indexPath.row].id){
                (request: HTTPURLResponse) in
                if request.statusCode == 200 {
                    self.groups.remove(at: indexPath.row)
                }
            }
        }
        
        let update = UITableViewRowAction(style: .normal, title: "UPDATE"){(action, indexPath) in
            self.updateGroup(index: indexPath.row)
        }
        return[delete,update]
    }
}
