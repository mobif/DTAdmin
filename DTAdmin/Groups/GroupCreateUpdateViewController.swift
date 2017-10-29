//
//  CreateUpdateViewController.swift
//  DTAdmin
//
//  Created by Admin on 20.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GroupCreateUpdateViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBAction func saveGroup(_ sender: Any) {
        if groupForUpdate != nil {
            self.updateGroup()
        } else {
            self.saveNewGroup()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var selectFacultyButton: UIButton!
    
    @IBOutlet weak var selectSpecialityButton: UIButton!
    
    @IBAction func selectFacultyTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
        let facultyViewController = storyBoard.instantiateViewController(withIdentifier: "FacultyViewController") as! FacultyForGroupViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(facultyViewController, animated: true)
            facultyViewController.selectFaculty = { selectedFaculty in
                self.faculty = selectedFaculty
                self.selectFacultyButton.titleLabel?.text = selectedFaculty.name
            }
        }
    }
    
    @IBAction func selectSpecialityTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
        let specialityViewController = storyBoard.instantiateViewController(withIdentifier: "SpecialityViewController") as! SpecialityForGroupViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(specialityViewController, animated: true)
            specialityViewController.selectSpeciality = { selectedSpeciality in
                self.speciality = selectedSpeciality
                self.selectSpecialityButton.titleLabel?.text = selectedSpeciality.name
            }
        }
    }
    
    var saveAction: ((Group) -> ())?
    var faculty: Faculty?
    var speciality: Speciality?
    var groupForUpdate: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupForUpdate != nil {
            self.title = "Update"
            guard let groupName = self.groupForUpdate?.name,
                let groupFacultId = self.groupForUpdate?.facultyId,
                let groupSpecialityId = self.groupForUpdate?.specialityId else { return }
            self.groupNameTextField.text = groupName
            HTTPService.getData(entityName: "faculty", id: groupFacultId) {
                (facultyJSON,facultyResponce) in
                if facultyResponce.statusCode == 200 {
                    let faculty = facultyJSON.flatMap{Faculty(dictionary: $0)}
                    if faculty.first != nil {
                        DispatchQueue.main.async {
                            self.selectFacultyButton.titleLabel?.text = faculty.first?.name
                        }
                    }
                }
            }
            HTTPService.getData(entityName: "speciality", id: groupSpecialityId) {
                (specialityJSON,specialityResponce) in
                if specialityResponce.statusCode == 200 {
                    let speciality = specialityJSON.flatMap{Speciality(dictionary: $0)}
                    if speciality.first != nil {
                        DispatchQueue.main.async {
                            self.selectSpecialityButton.titleLabel?.text = speciality.first?.name
                        }
                    }
                }
            }
        } else {
            self.title = "Create"
        }
    }
    
    func updateGroup() {
        guard let newGroupName = self.groupNameTextField.text else { return }
        guard let newGroupFacultyId = self.faculty?.id ?? self.groupForUpdate?.facultyId else { return }
        guard let newGroupSpecialityId = self.speciality?.id ?? self.groupForUpdate?.specialityId else { return }
        let params = [
            "group_name": newGroupName,
            "speciality_id": newGroupSpecialityId,
            "faculty_id": newGroupFacultyId
        ]
        guard let id = self.groupForUpdate?.id else { return }
        HTTPService.putData(entityName: "group", id: id, postData: params) {
            (result: HTTPURLResponse,updatedGroupData: [[String:String]]) in
            if result.statusCode == 200 {
                let groups = updatedGroupData.flatMap{Group(dictionary: $0)}
                guard let updatedGroup = groups.first else { return }
                self.saveAction!(updatedGroup)
            }
        }
    }
    
    func saveNewGroup() {
        guard let newGroupName = self.groupNameTextField.text else { return }
        guard let newGroupFacultyId = self.faculty?.id else { return }
        guard let newGroupSpecialityId = self.speciality?.id else { return }
        let params = [
            "group_name": newGroupName,
            "speciality_id": newGroupSpecialityId,
            "faculty_id": newGroupFacultyId
        ]
        HTTPService.postData(entityName: "group", postData: params) {
            (result: HTTPURLResponse,newGroupData: [[String:String]]) in
            if result.statusCode == 200 {
                let groups = newGroupData.flatMap{Group(dictionary: $0)}
                guard let newGroup = groups.first else { return }
                self.saveAction!(newGroup)
            }
        }
    }
}
