//
//  CreateUpdateViewController.swift
//  DTAdmin
//
//  Created by Admin on 20.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class CreateUpdateViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var selectFacultyButton: UIButton!
    
    @IBOutlet weak var selectSpecialityButton: UIButton!
    @IBAction func selectFacultyTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
        let facultyViewController = storyBoard.instantiateViewController(withIdentifier: "FacultyViewController") as! FacultyViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(facultyViewController, animated: true)
            facultyViewController.selectFaculty = { selectedFaculty in
                self.faculty = selectedFaculty
                self.selectFacultyButton.titleLabel?.lineBreakMode = .byWordWrapping
                self.selectFacultyButton.titleLabel?.numberOfLines = 0
                self.selectFacultyButton.titleLabel?.text = selectedFaculty.facultyName
            }
        }
    }
    
    @IBAction func selectSpecialityTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
        let specialityViewController = storyBoard.instantiateViewController(withIdentifier: "SpecialityViewController") as! SpecialityViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(specialityViewController, animated: true)
            specialityViewController.selectSpeciality = { selectedSpeciality in
                self.speciality = selectedSpeciality
                self.selectSpecialityButton.titleLabel?.lineBreakMode = .byWordWrapping
                self.selectSpecialityButton.titleLabel?.numberOfLines = 0
                self.selectSpecialityButton.titleLabel?.text = selectedSpeciality.specialityName
                
            }
            
        }
    }
    var faculty: Faculty?
    var speciality: Speciality?
    var indexForUpdateGroup: Int?
    var groupForUpdate: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupForUpdate != nil {
            self.title = "Update"
            let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveNewGroup))
            self.navigationItem.rightBarButtonItem = rightButton
        } else {
            self.title = "Create"
            let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.updateGroup))
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveNewGroup (sender: UIBarButtonItem) {
        guard let newGroupName = self.groupNameTextField.text else { return }
        print(newGroupName)
        guard let newGroupFacultyId = self.faculty?.facultyId else { return }
        print(String(newGroupFacultyId))
        guard let newGroupSpecialityId = self.speciality?.specialityId else { return }
        print(String(newGroupSpecialityId))
        let params = [
            "group_name": newGroupName,
            "speciality_id": newGroupSpecialityId,
            "faculty_id": newGroupFacultyId
        ]
        HTTPService.postData(entityName: "group", postData: params) {
            (result: HTTPURLResponse,newGroupData: [[String:String]]) in
            if result.statusCode == 200 {
                let newGroup = Group.getGroupsFromJSON(json: newGroupData).first
                newGroup?.facultyName = self.faculty?.facultyName
                newGroup?.facultyDescription = self.faculty?.facultyDescription
                newGroup?.specialityName = self.speciality?.specialityName
                newGroup?.specialityCode = self.speciality?.specialityCode
                let groupViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! GroupViewController
                groupViewController.newGroup = newGroup
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc func updateGroup (sender: UIBarButtonItem) {
        print("update")
        print(self.groupForUpdate!)
//        guard let updateGroupId = self.groupForUpdate?.groupId else { return }
//        let updateGroupName = self.groupNameTextField.text != nil ? self.groupNameTextField.text! : self.groupForUpdate?.groupName
//        let updateGroupFacultyId = self.faculty?.facultyId != nil ? self.faculty?.facultyId : self.groupForUpdate?.facultyId
//        let updateGroupSpecialityId = self.speciality?.specialityId != nil ? self.speciality?.specialityId : self.groupForUpdate?.specialityId
        guard let updateGroupId = self.groupForUpdate?.groupId,
            let updateGroupName = self.groupNameTextField.text ?? self.groupForUpdate?.groupName,
            let updateGroupFacultyId = self.faculty?.facultyId ?? self.groupForUpdate?.facultyId,
            let updateGroupSpecialityId = self.speciality?.specialityId ?? self.groupForUpdate?.specialityId else { return }
        let params = [
            "group_name": updateGroupName,
            "speciality_id": updateGroupSpecialityId,
            "faculty_id": updateGroupFacultyId
        ]
        HTTPService.putData(entityName: "group", id: updateGroupId, postData: params) {
            (result: HTTPURLResponse, newGroupData: [[String:String]]) in
            if result.statusCode == 200 {
                let updatedGroup = Group.getGroupsFromJSON(json: newGroupData).first
                if updatedGroup != nil {
                    updatedGroup?.facultyName = self.faculty?.facultyName != nil ? self.faculty?.facultyName : self.groupForUpdate?.facultyName
                    updatedGroup?.facultyDescription = self.faculty?.facultyDescription != nil ? self.faculty?.facultyDescription : self.groupForUpdate?.facultyDescription
                    updatedGroup?.specialityName = self.speciality?.specialityName != nil ? self.speciality?.specialityName : self.groupForUpdate?.specialityName
                    updatedGroup?.specialityCode = self.speciality?.specialityCode != nil ? self.speciality?.specialityCode : self.groupForUpdate?.specialityCode
                    let groupViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! GroupViewController
                    groupViewController.updatedGroup = updatedGroup
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
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
