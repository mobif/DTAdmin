//
//  GroupViewController.swift
//  DTAdmin
//
//  Created by Admin on 19.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GroupViewController: ParentViewController {
    
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBAction func createNewGroup(_ sender: Any) {
        guard let createUpdateGroupViewController = getCreateUpdateGroupViewController() else { return }
        createUpdateGroupViewController.saveAction = { newGroup in
            self.groups.append(newGroup)
        }
        navigationController?.pushViewController(createUpdateGroupViewController, animated: true)
    }
    
    var isSelectAction: Bool?
    var refreshControl: UIRefreshControl?
    /**
     This clousure perfoms by transmitting the object to be selected by the user to other controllers
     */
    var selectGroup: ((GroupStructure) -> ())?
    var groups = [GroupStructure]() {
        didSet {
            DispatchQueue.main.async {
                self.groupTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Groups", comment: "Title for Groups table view")
        groupTableView.delegate = self
        groupTableView.dataSource = self
        refreshControl = UIRefreshControl()
        updateTable()
        refreshControl!.tintColor = UIColor.red
        refreshControl!.backgroundColor = UIColor.gray
        refreshControl!.attributedTitle = NSAttributedString(string: "wait")
        refreshControl!.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        if #available(iOS 10.0, *){
            groupTableView.refreshControl = refreshControl
        } else {
            groupTableView.addSubview(refreshControl!)
        }
        
    }
    
    @objc func updateTable() {
        startActivity()
        DataManager.shared.getList(byEntity: .Group) { (groups, error) in
            self.stopActivity()
            guard let groups = groups as? [GroupStructure] else {
                DispatchQueue.main.async {
                    self.refreshControl!.endRefreshing()
                }
                self.showWarningMsg(error ?? "Incorect data")
                return
            }
            self.groups = groups
            DispatchQueue.main.async {
                self.groupTableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
        
    }
    
    func getCreateUpdateGroupViewController() -> GroupCreateUpdateViewController? {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Group", bundle: nil)
        guard let creteUpdateGroupViewController = storyBoard.instantiateViewController(withIdentifier: "CreateUpdateVC") as? GroupCreateUpdateViewController else { return nil }
        return creteUpdateGroupViewController
    }
    
    func updateGroup(index: Int) {
        guard let createUpdateGroupViewController = getCreateUpdateGroupViewController() else { return }
        createUpdateGroupViewController.groupForUpdate = self.groups[index]
        createUpdateGroupViewController.saveAction = { updatedGroup in
            if let indexPath = self.groups.index(where: {$0.groupId == updatedGroup.groupId}) {
                self.groups[indexPath] = updatedGroup
            } else {
                print("wrong index for update")
            }
        }
        navigationController?.pushViewController(createUpdateGroupViewController, animated: true)
    }
    
    func showGroupDetails(group: GroupStructure) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Group", bundle: nil)
        guard let groupDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "GroupDetailsVC") as? GroupDetailsViewController else { return }
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
        cell.textLabel?.text = groups[indexPath.row].groupName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "DELETE"){(action, indexPath) in
            DataManager.shared.deleteEntity(byId: self.groups[indexPath.row].groupId!, typeEntity: .Group, completionHandler: { (status, error) in
                if let error = error {
                    self.showWarningMsg(error)
                } else {
                    self.groups.remove(at: indexPath.row)
                }
            })
        }
        let update = UITableViewRowAction(style: .normal, title: "UPDATE"){(action, indexPath) in
            self.updateGroup(index: indexPath.row)
        }
        return[delete,update]
    }
}




