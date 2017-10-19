//
//  GroupVC.swift
//  DTAdmin
//
//  Created by Admin on 18.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GroupVC: UIViewController {
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var commonData = [Group]()
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        getCommonArrayForGroups(){(result:[Group]) in
            for i in result {
                print("value \(i)\n")
                print("name \(String(describing: i.group_name))\n")
            }
            self.commonData = result
            
            print("common")
            print(self.commonData)
            }
    }
    
    func getCommonArrayForGroups (completion: @escaping ([Group]) -> ()){
        
        var groups:[Group] = []
        var faculties:[Faculty] = []
        var specialities:[Speciality] = []
        
        HTTPService.getAllData(entityName: "group"){ (result:[Group],responce) in
            if responce.statusCode == 200 {
                groups = result
                HTTPService.getAllData(entityName: "faculty"){ (result:[Faculty],responce) in
                    if responce.statusCode == 200 {
                        faculties = result
                        HTTPService.getAllData(entityName: "speciality"){ (result:[Speciality],responce) in
                            if responce.statusCode == 200 {
                                specialities = result
                                for group in groups {
                                    for faculty in faculties {
                                        if (group.faculty_id == faculty.faculty_id){
                                            group.faculty_name = faculty.faculty_name
                                            group.faculty_description = faculty.faculty_description
                                        }
                                    }
                                    for speciality in specialities {
                                        if (group.speciality_id == speciality.speciality_id){
                                            group.speciality_name = speciality.speciality_name
                                            group.speciality_code = speciality.speciality_name
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
extension GroupVC : UITableViewDelegate {
   
}

//MARK: table view data source
extension GroupVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupCell")! as UITableViewCell
        cell.textLabel?.text = commonData[indexPath.row].group_name
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonData.count
    }

}

