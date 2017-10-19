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
    
    var commonDataForGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        getCommonArrayForGroups(){(result:[Group]) in
            self.commonDataForGroups = result
            DispatchQueue.main.async {
                self.groupTableView.reloadData()
            }
        }
    }
    
    func getCommonArrayForGroups (completion: @escaping ([Group]) -> ()) {
        var groups = [Group]()
        HTTPService.getAllData(entityName: "group") {
            (groupJSON:[[String:String]],groupResponce) in
            groups = Group.getGroupsFromJSON(json: groupJSON)
            print(groups)
            if groupResponce.statusCode == 200 {
                HTTPService.getAllData(entityName: "faculty") {
                    (facultyJSON:[[String:String]],facultyResponce) in
                    let faculties = Faculty.getFacultiesFromJSON(json: facultyJSON)
                    print(faculties)
                    if facultyResponce.statusCode == 200 {
                        HTTPService.getAllData(entityName: "speciality")  {
                            (specialityJSON:[[String:String]],specialityResponce) in
                            let specialities = Speciality.getSpecialitiesFromJSON(json: specialityJSON)
                            print(specialities)
                            if specialityResponce.statusCode == 200 {
                                for group in groups {
                                    for faculty in faculties {
                                        if (group.facultyId == faculty.facultyId) {
                                            group.facultyName = faculty.facultyName
                                            group.facultyDescription = faculty.facultyDescription
                                        }
                                    }
                                    for speciality in specialities {
                                        if (group.specialityId == speciality.specialityId) {
                                            group.specialityName = speciality.specialityName
                                            group.specialityCode = speciality.specialityCode
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: table view delegate
extension GroupViewController : UITableViewDelegate {
    
}

//MARK: table view data source
extension GroupViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = commonDataForGroups[indexPath.row].groupName
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonDataForGroups.count
    }
    
}
