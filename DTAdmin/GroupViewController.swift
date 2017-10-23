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
            self.commonDataForGroups.append(newGroup)
        }
        navigationController?.pushViewController(createUpdateGroupViewController, animated: true)
    }
    
    var commonDataForGroups = [Group]() {
        didSet {
            DispatchQueue.main.async {
                self.groupTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        groupTableView.delegate = self
        groupTableView.dataSource = self
        getCommonArrayForGroups(){(result:[Group]) in
            self.commonDataForGroups = result
        }
    }
    
    @objc func getCreateUpdateGroupViewController() -> CreateUpdateViewController? {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
        let creteUpdateGroupViewController = storyBoard.instantiateViewController(withIdentifier: "CreateUpdateVC") as! CreateUpdateViewController
        return creteUpdateGroupViewController
    }
    
    @objc func createNewGroup() {
        guard let createUpdateGroupViewController = getCreateUpdateGroupViewController() else { return }
        createUpdateGroupViewController.saveAction = { newGroup in
            self.commonDataForGroups.append(newGroup)
        }
        navigationController?.pushViewController(createUpdateGroupViewController, animated: true)
    }
    
    @objc func updateGroup(index: Int) {
        guard let createUpdateGroupViewController = getCreateUpdateGroupViewController() else { return }
        createUpdateGroupViewController.groupForUpdate = self.commonDataForGroups[index]
        createUpdateGroupViewController.saveAction = { updatedGroup in
            if let index = self.commonDataForGroups.index(where: {$0.id == updatedGroup.id}) {
                self.commonDataForGroups[index] = updatedGroup
            } else {
                print("wrong index for update")
            }
        }
        navigationController?.pushViewController(createUpdateGroupViewController, animated: true)
    }
    
    func getCommonArrayForGroups (completion: @escaping ([Group]) -> ()) {
        var groups = [Group]()
        HTTPService.getAllData(entityName: "group") {
            (groupJSON:[[String:String]],groupResponce) in
            groups = groupJSON.flatMap{Group(dictionary: $0)}
            print(groups)
            if groupResponce.statusCode == 200 {
                HTTPService.getAllData(entityName: "faculty") {
                    (facultyJSON:[[String:String]],facultyResponce) in
                    let faculties = facultyJSON.flatMap{Faculty(dictionary: $0)}
                    print(faculties)
                    if facultyResponce.statusCode == 200 {
                        HTTPService.getAllData(entityName: "speciality")  {
                            (specialityJSON:[[String:String]],specialityResponce) in
                            let specialities = specialityJSON.flatMap{Speciality(dictionary: $0)}
                            print(specialities)
                            if specialityResponce.statusCode == 200 {
                                for group in groups {
                                    for faculty in faculties {
                                        if (group.facultyId == faculty.id) {
                                            group.facultyName = faculty.name
                                            group.facultyDescription = faculty.description
                                        }
                                    }
                                    for speciality in specialities {
                                        if (group.specialityId == speciality.id) {
                                            group.specialityName = speciality.name
                                            group.specialityCode = speciality.code
                                        }
                                    }
                                }
                                completion(groups)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: table view delegate
extension GroupViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateGroup(index: indexPath.row)
    }
}

//MARK: table view data source
extension GroupViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = commonDataForGroups[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonDataForGroups.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "DELETE"){(action, indexPath) in
            HTTPService.deleteData(entityName: "group", id: self.commonDataForGroups[indexPath.row].id){
                (request: HTTPURLResponse) in
                if request.statusCode == 200 {
                    self.commonDataForGroups.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.groupTableView.reloadData()
                    }
                }
            }
        }
        return[delete]
    }
}
