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
    
    var commonData = [[String: String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        getCommonArrayForGroups(){(result:[[String:String]]) in
//            for i in result {
//                print("value \(i)\n")
//            }
//            let json = JSONSerialization.data(withJSONObject: result, options: [])
//            self.commonData = json as [[String: String]]
            print("common")
            print(self.commonData)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCommonArrayForGroups (completion: @escaping ([[String:String]]) -> ()){
        
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
                                var commonData:[[String:String]] = []
                                for group in groups {
                                    var newGroup:[String:String] = [:]
                                    newGroup["group_name"] = group.group_name
                                    newGroup["group_id"] = group.group_id
                                    newGroup["faculty_id"] = group.faculty_id
                                    newGroup["speciality_id"] = group.speciality_id
                                    for faculty in faculties {
                                        if (group.faculty_id == faculty.faculty_id){
                                            newGroup["faculty_name"] = faculty.faculty_name
                                            newGroup["faculty_description"] = faculty.faculty_description
                                        }
                                    }
                                    for speciality in specialities {
                                        if (group.speciality_id == speciality.speciality_id){
                                            newGroup["speciality_code"] = speciality.speciality_code
                                            newGroup["speciality_name"] = speciality.speciality_name
                                        }
                                    }
                                    commonData.append(newGroup)
                                }
                                completion(commonData)
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
        cell.textLabel?.text = commonData[indexPath.row]["group_name"]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonData.count
    }

}

