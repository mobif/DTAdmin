//
//  EditStudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController {
    var studentLoaded: StudentStructure?
    var studentForSave: StudentStructure?
    
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
        if let studentLoaded = studentLoaded {
            nameStudentTextField.text = studentLoaded.studentName
            familyNameStudentTextField.text = studentLoaded.studentFname
            surnameStudentTextField.text = studentLoaded.studentSurname
            passwordStudentTextField.text = studentLoaded.plainPassword
            gradeBookIdTextField.text = studentLoaded.gradebookId
            getGroupFromAPI(byId: studentLoaded.groupId)
            getUserFromAPI(byId: studentLoaded.userId)
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
        if prepareForSave(){
            guard let userIDForUpdate = studentLoaded?.userId else { return }
            guard let studentForSave = studentForSave else { return }
            RequestManager.updateEntity(byId: userIDForUpdate, entity: studentForSave, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    self.showWarningMsg(error)
                } else {
                    self.navigationController?.popViewController(animated: true)
                } })
        }
    }
    
    @objc func postNewStudentToAPI(){
        if prepareForSave(){
            guard let studentForSave = studentForSave else { return }
            RequestManager.insertEntity(entity: studentForSave, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    print(error!)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func prepareForSave() -> Bool {
        var json:[String:String]
        json["username"] = loginStudentTextField.text
        json["email"] = emailStudentTextField.text
        json["student_name"] = nameStudentTextField.text
        json["student_surname"] = surnameStudentTextField.text
        json["student_fname"] = familyNameStudentTextField.text
        json["gradebook_id"] = gradeBookIdTextField.text
        json["password"] = passwordStudentTextField.text
        json["password_confirm"] = passwordConfirmTextField.text
        json["plain_password"] = passwordConfirmTextField.text
        json["group"] = selectedGroupForStudent?.groupId
        
        let newStudent = StudentStructure(json: json)
        
        if (newStudent.name.count > 2) && (surName.count > 2) && (fName.count > 1) && (gradeBook.count > 4) && (pass.count > 6) && (pass == passConfirm){
            
            
            studentForSave = StudentStructure(userName: login, password: pass, passwordConfirm: passConfirm, plain_password: pass, email: email, gradebook_id: gradeBook, student_surname: sname, student_name: name, student_fname: fname, group_id: group, photo: "")
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
        var groupForCurrentStudent: GroupStructure?
        RequestManager.getEntity(byId: byId, entityStructure: Entities.Group, type: groupForCurrentStudent, returnResults: { (groupInstance, error) in
            if let groupInstance = groupInstance, error == nil {
                groupForCurrentStudent = groupInstance
            }
            guard let groupForCurrentStudentUnwraped = groupForCurrentStudent else { return }
            self.selectedGroupForStudent = groupForCurrentStudentUnwraped
            self.groupButton.setTitle(groupForCurrentStudentUnwraped.groupName, for: .normal)
        })
    }
    func getUserFromAPI(byId: String) {
        var userForCurrentStudent: UserGetStructure?
        RequestManager.getEntity(byId: byId, entityStructure: Entities.User, type: userForCurrentStudent, returnResults: { (userInstance, error) in
            if let userInstance = userInstance, error == nil {
                userForCurrentStudent = userInstance
            }
            self.selectedUserAccountForStudent = userForCurrentStudent
            self.loginStudentTextField.text = userForCurrentStudent?.username
            self.emailStudentTextField.text = userForCurrentStudent?.email
        })
    }
    
}
