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
    @IBAction func saveGroup(_ sender: Any) {
        if groupForUpdate != nil {
            self.updateGroup()
        } else {
            self.saveNewGroup()
        }
    }
    
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
                self.selectFacultyButton.titleLabel?.text = selectedFaculty.name
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
                let groupFacultName = self.groupForUpdate?.facultyName,
                let groupSpecialityName = self.groupForUpdate?.specialityName! else { return }
            self.view.layoutIfNeeded()
            self.groupNameTextField.text = groupName
            self.selectFacultyButton.titleLabel?.text = groupFacultName
            self.selectSpecialityButton.titleLabel?.text = groupSpecialityName
        } else {
            self.title = "Create"
        }
    }
    
    @objc func updateGroup() {
        guard let newGroupName = self.groupNameTextField.text else { return }
        guard let newGroupFacultyId = self.faculty?.id else { return }
        guard let newGroupSpecialityId = self.speciality?.id else { return }
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
                groups.first?.facultyName = self.faculty?.name ?? self.groupForUpdate?.facultyName
                groups.first?.facultyDescription = self.faculty?.description ?? self.groupForUpdate?.facultyDescription
                groups.first?.specialityName = self.speciality?.name ?? self.groupForUpdate?.specialityName
                groups.first?.specialityCode = self.speciality?.code ?? self.groupForUpdate?.specialityCode
                guard let updatedGroup = groups.first else { return }
                self.saveAction!(updatedGroup)
            }
        }
    }
    
    @objc func saveNewGroup() {
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
                groups.first?.facultyName = self.faculty?.name
                groups.first?.facultyDescription = self.faculty?.description
                groups.first?.specialityName = self.speciality?.name
                groups.first?.specialityCode = self.speciality?.code
                guard let newGroup = groups.first else { return }
                self.saveAction!(newGroup)
            }
        }
    }
}
