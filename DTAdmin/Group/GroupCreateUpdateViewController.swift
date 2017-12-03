//
//  CreateUpdateViewController.swift
//  DTAdmin
//
//  Created by Admin on 20.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GroupCreateUpdateViewController: ParentViewController {
    
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Faculty", bundle: nil)
        guard let facultyViewController = storyBoard.instantiateViewController(withIdentifier: "FacultyViewController") as? FacultyViewController else { return }
        self.navigationController?.pushViewController(facultyViewController, animated: true)
        facultyViewController.getFaculty = true
        facultyViewController.selectFaculty = { selectedFaculty in
            self.faculty = selectedFaculty
            self.selectFacultyButton.titleLabel?.text = selectedFaculty.name
        }
    }
    
    @IBAction func selectSpecialityTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Speciality", bundle: nil)
        guard let specialitiesViewController = storyBoard.instantiateViewController(withIdentifier: "SpecialitiesViewController") as? SpecialitiesViewController else { return }
        self.navigationController?.pushViewController(specialitiesViewController, animated: true)
        specialitiesViewController.getSpeciality = true
        specialitiesViewController.selectSpeciality = { selectedSpeciality in
            self.speciality = selectedSpeciality
            self.selectSpecialityButton.titleLabel?.text = selectedSpeciality.name
        }
    }
    
    var saveAction: ((GroupStructure) -> ())?
    var faculty: FacultyStructure?
    var speciality: SpecialityStructure?
    var groupForUpdate: GroupStructure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupForUpdate != nil {
            self.title = NSLocalizedString("Update", comment: "Title for update group")
            guard let groupName = self.groupForUpdate?.groupName,
                let groupFacultId = self.groupForUpdate?.facultyId,
                let groupSpecialityId = self.groupForUpdate?.specialityId else { return }
            self.groupNameTextField.text = groupName
            self.view.layoutIfNeeded()
            DataManager.shared.getEntity(byId: groupFacultId, typeEntity: .faculty){
                (faculty, error) in
                if let error = error {
                    self.showWarningMsg(error.info)
                } else {
                    guard let faculty = faculty as? FacultyStructure else { return }
                    DispatchQueue.main.async {
                        self.selectFacultyButton.titleLabel?.text = faculty.name
                    }
                }
            }
            DataManager.shared.getEntity(byId: groupSpecialityId, typeEntity: .speciality){
                (speciality, error) in
                if let error = error {
                    self.showWarningMsg(error.info)
                } else {
                    guard let speciality = speciality as? SpecialityStructure else { return }
                    DispatchQueue.main.async {
                        self.selectFacultyButton.titleLabel?.text = speciality.name
                    }
                }
            }
        } else {
            self.title = NSLocalizedString("Create", comment: "Title for create new group")
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
        guard var groupForUpdate = GroupStructure(dictionary: params) else { return }
        guard let id = self.groupForUpdate?.groupId else { return }
        DataManager.shared.updateEntity(byId: id, entity: groupForUpdate, typeEntity: .group){
            (error) in
            if let error = error {
                self.showWarningMsg(error.info)
            } else {
                groupForUpdate.groupId = id
                guard let saveAction = self.saveAction else { return }
                saveAction(groupForUpdate)
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
        guard var groupForSave = GroupStructure(dictionary: params) else { return }
        DataManager.shared.insertEntity(entity: groupForSave, typeEntity: .group) {
            (id, error) in
            if let error = error {
                self.showWarningMsg(error.info)
            } else {
                guard let id = id as? String else { return }
                groupForSave.groupId = id
                guard let saveAction = self.saveAction else { return }
                saveAction(groupForSave)
            }
        }
    }
}
