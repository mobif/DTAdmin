//
//  EditStudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController {
    var studentLoaded: StudentGetStructure?
    var studentForSave: StudentPostStructure?
    
    @IBOutlet weak var loginStudentTextField: UITextField!
    @IBOutlet weak var emailStudentTextField: UITextField!
    @IBOutlet weak var nameStudentTextField: UITextField!
    @IBOutlet weak var familyNameStudentTextField: UITextField!
    @IBOutlet weak var surnameStudentTextField: UITextField!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var passwordStudentTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var gradeBookIdTextField: UITextField!
    var titleViewController: String?
    var selectedGroupForStudent: GroupStructure?
    var selectedUserAccountForStudent: UserGetStructure?
    var isNewStudent = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton: UIBarButtonItem
        if studentLoaded != nil {
            nameStudentTextField.text = studentLoaded!.studentName
            familyNameStudentTextField.text = studentLoaded!.studentFname
            surnameStudentTextField.text = studentLoaded!.studentSurname
            passwordStudentTextField.text = studentLoaded!.plainPassword
            gradeBookIdTextField.text = studentLoaded!.gradebookId
            
            getGroupFromAPI(byId: studentLoaded!.groupId)
            getUserFromAPI(byId: studentLoaded!.userId)
            saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.postUpdateStudentToAPI))
            isNewStudent = false
        } else {
            
            saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.postNewStudentToAPI))
            isNewStudent = true
        }
        navigationItem.rightBarButtonItem = saveButton
        if titleViewController != nil {
            navigationItem.title = titleViewController
        }
    }
    
    @objc func postUpdateStudentToAPI(){
        let postMan = PostManager<StudentPostStructure>()
        if prepareForSave(){
            guard let userIDForUpdate = studentLoaded?.userId else { return }
            postMan.updateEntity(byId: userIDForUpdate, entity: studentForSave!, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    print(error!)
                } else {
                    self.navigationController?.popViewController(animated: true)
                } })
        }
    }
    
    @objc func postNewStudentToAPI(){
        let postMan = PostManager<StudentPostStructure>()
        if prepareForSave(){
            postMan.insertEntity(entity: studentForSave!, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    print(error!)
                } else {
                    self.navigationController?.popViewController(animated: true)
                } })
        }
    }
    
    func prepareForSave() -> Bool {
        guard let login = loginStudentTextField.text else { return false}
        guard let email = emailStudentTextField.text else { return false}
        guard let name = nameStudentTextField.text else { return false}
        guard let sname = surnameStudentTextField.text else { return false}
        guard let fname = familyNameStudentTextField.text else { return false}
        guard let gradebook = gradeBookIdTextField.text else { return false}
        guard let pass = passwordStudentTextField.text else { return false}
        guard let passConfirm = passwordConfirmTextField.text else { return false}
        guard let group = selectedGroupForStudent?.groupId else { return false}
        
        
        if (name.count > 2) && (sname.count > 2) && (fname.count > 1) && (gradebook.count > 4) && (pass.count > 6) && (pass == passConfirm){
            studentForSave = StudentPostStructure(userName: login, password: pass, passwordConfirm: passConfirm, plainPassword: pass, email: email, gradebookId: gradebook, studentSurname: sname, studentName: name, studentFname: fname, groupId: group, photo: "")
        } else {
            return false
        }
        return true
    }
    
    @IBAction func selectGroup(_ sender: UIButton) {
        guard let groupsViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "GroupsTableViewController") as? GroupsTableViewController else {return}
        groupsViewController.titleViewController = "Groups"
        groupsViewController.selecectedGroup = {
            group in
            self.selectedGroupForStudent = group
            self.groupButton.setTitle(group.groupName, for: .normal)
        }
        self.navigationController?.pushViewController(groupsViewController, animated: true)
    }
    func getGroupFromAPI(byId: String){
        let manager = RequestManager<GroupStructure>()
        var groupForCurrentStudent: GroupStructure?
        manager.getEntity(byId: byId, entityStructure: Entities.Group, returnResults: { (groupInstance, error) in
            if groupInstance != nil {
                groupForCurrentStudent = groupInstance!
            }
            self.selectedGroupForStudent = groupInstance
            self.groupButton.setTitle(groupForCurrentStudent!.groupName, for: .normal)
        })
    }
    func getUserFromAPI(byId: String) {
        let manager = RequestManager<UserGetStructure>()
        var userForCurrentStudent: UserGetStructure?
        manager.getEntity(byId: byId, entityStructure: .User, returnResults: { (userInstance, error) in
            if userInstance != nil, error == nil {
                userForCurrentStudent = userInstance!
            }
            self.selectedUserAccountForStudent = userForCurrentStudent
            self.loginStudentTextField.text = userForCurrentStudent?.userName
            self.emailStudentTextField.text = userForCurrentStudent?.email
        })
    }
    
}
