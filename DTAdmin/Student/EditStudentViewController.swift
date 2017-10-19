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
        if let studentLoaded = studentLoaded {
            nameStudentTextField.text = studentLoaded.student_name
            familyNameStudentTextField.text = studentLoaded.student_fname
            surnameStudentTextField.text = studentLoaded.student_surname
            passwordStudentTextField.text = studentLoaded.plain_password
            gradeBookIdTextField.text = studentLoaded.gradebook_id
            getGroupFromAPI(byId: studentLoaded.group_id)
            getUserFromAPI(byId: studentLoaded.user_id)
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
            guard let userIDForUpdate = studentLoaded?.user_id else { return }
            guard let studentForSave = studentForSave else { return }
            RequestManager<StudentPostStructure>().updateEntity(byId: userIDForUpdate, entity: studentForSave, entityStructure: Entities.Student, returnResults: { error in
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
            RequestManager<StudentPostStructure>().insertEntity(entity: studentForSave, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    print(error!)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
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
        guard let group = selectedGroupForStudent?.group_id else { return false}
        
        
        if (name.count > 2) && (sname.count > 2) && (fname.count > 1) && (gradebook.count > 4) && (pass.count > 6) && (pass == passConfirm){
            studentForSave = StudentPostStructure(username: login, password: pass, password_confirm: passConfirm, plain_password: pass, email: email, gradebook_id: gradebook, student_surname: sname, student_name: name, student_fname: fname, group_id: group, photo: "")
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
            self.groupButton.setTitle(group.group_name, for: .normal)
        }
        self.navigationController?.pushViewController(groupsViewController, animated: true)
    }
    func getGroupFromAPI(byId: String){
        var groupForCurrentStudent: GroupStructure?
        RequestManager<GroupStructure>().getEntity(byId: byId, entityStructure: Entities.Group, returnResults: { (groupInstance, error) in
            if groupInstance != nil {
                groupForCurrentStudent = groupInstance!
            }
            self.selectedGroupForStudent = groupInstance
            self.groupButton.setTitle(groupForCurrentStudent!.group_name, for: .normal)
        })
    }
    func getUserFromAPI(byId: String) {
        var userForCurrentStudent: UserGetStructure?
        RequestManager<UserGetStructure>().getEntity(byId: byId, entityStructure: .User, returnResults: { (userInstance, error) in
            if userInstance != nil, error == nil {
                userForCurrentStudent = userInstance!
            }
            self.selectedUserAccountForStudent = userForCurrentStudent
            self.loginStudentTextField.text = userForCurrentStudent?.username
            self.emailStudentTextField.text = userForCurrentStudent?.email
        })
    }
    
}
