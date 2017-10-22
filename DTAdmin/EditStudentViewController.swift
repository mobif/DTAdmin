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
    var resultModification: ((StudentGetStructure, Bool) -> ())?
    
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
        let postMan = PostManager<StudentPostStructure>()
        if prepareForSave(){
            guard let userIDForUpdate = studentLoaded?.userId else { return }
            guard let studentForSave = studentForSave else { return }
            postMan.updateEntity(byId: userIDForUpdate, entity: studentForSave, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    print(error!)
                } else {
                    if let resultModification = self.resultModification {
                        resultModification(studentForSave.convertToGetStructure(id: userIDForUpdate), false)
                    }
                    self.navigationController?.popViewController(animated: true)
                } })
            
        }
    }
    
    @objc func postNewStudentToAPI(){
        let postMan = PostManager<StudentPostStructure>()
        if prepareForSave(){
            guard let studentForSave = studentForSave else { return }
            postMan.insertEntity(entity: studentForSave, entityStructure: Entities.Student, returnResults: { (resultString, error) in
                if let error = error {
                        self.showWarningMsg(error)
                } else {
                    guard let resultStringUnwraper = resultString else {
                        self.showWarningMsg("No server response")
                        return
                    }
                    let dictionaryResult = self.convertToDictionary(text: resultStringUnwraper)
                    guard let dictionaryResultUnwraped = dictionaryResult else {
                        self.showWarningMsg("Incorect response structure")
                        return
                    }
                    guard let newUserId = self.getIdAsInt(dict: dictionaryResultUnwraped) else {
                        self.showWarningMsg("Incorect response structure")
                        return
                    }
                    
                    if let resultModification = self.resultModification {
                        resultModification(studentForSave.convertToGetStructure(id: newUserId), true)
                    }
                    self.navigationController?.popViewController(animated: true)
                } })
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                print(text)
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return dict
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getIdAsInt(dict: [String: Any]) -> String? {
        let id = dict["id"] as? Int
        guard let idValue = id else { return nil }
        return String(idValue)
    }
    
    func prepareForSave() -> Bool {
        guard let login = loginStudentTextField.text,
         let email = emailStudentTextField.text,
         let name = nameStudentTextField.text,
         let sname = surnameStudentTextField.text,
         let fname = familyNameStudentTextField.text,
         let gradebook = gradeBookIdTextField.text,
         let pass = passwordStudentTextField.text,
         let passConfirm = passwordConfirmTextField.text,
         let group = selectedGroupForStudent?.groupId else { return false}
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
