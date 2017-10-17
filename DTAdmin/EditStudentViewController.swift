//
//  EditStudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController {
    var student: StudentStructure?
    @IBOutlet weak var nameStudentTextField: UITextField!
    @IBOutlet weak var familyNameStudentTextField: UITextField!
    @IBOutlet weak var surnameStudentTextField: UITextField!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var passwordStudentTextField: UITextField!
    @IBOutlet weak var gradeBookIdTextField: UITextField!
    var titleViewController: String?
    var selectedGroupForStudent: GroupStructure?
    override func viewDidLoad() {
        super.viewDidLoad()
        if student != nil {
            nameStudentTextField.text = student!.student_name
            familyNameStudentTextField.text = student!.student_fname
            surnameStudentTextField.text = student!.student_surname
            passwordStudentTextField.text = student!.plain_password
            gradeBookIdTextField.text = student!.gradebook_id
            getGroupFromAPI(byId: student!.group_id)
        } else {
            let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.postNewStudentToAPI))
            navigationItem.rightBarButtonItem = saveButton
        }
        if titleViewController != nil {
            navigationItem.title = titleViewController
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func postNewStudentToAPI(){
        let postMan = PostManager<StudentStructure>()
        if cheakStudentFields(){
            postMan.insertEntity(entity: student!, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    print(error!)
                } else {
                    self.navigationController?.popViewController(animated: true)
                } })
        }
    }
    
    func cheakStudentFields() -> Bool {
        guard let name = nameStudentTextField.text else { return false}
        guard let sname = surnameStudentTextField.text else { return false}
        guard let fname = familyNameStudentTextField.text else { return false}
        guard let gradebook = gradeBookIdTextField.text else { return false}
        guard let pass = passwordStudentTextField.text else { return false}
        guard let group = selectedGroupForStudent else { return false}
        if (name.count > 2) && (sname.count > 2) && (fname.count > 1) && (gradebook.count > 4) && (pass.count > 6) {
            if student == nil {
                student = StudentStructure(user_id: "0", gradebook_id: gradebook, student_surname: sname, student_name: name, student_fname: fname, group_id: group.group_id, plain_password: pass, photo: "")
            } else {
                student?.student_name = name
                student?.student_fname = fname
                student?.student_surname = sname
                student?.plain_password = pass
                student?.gradebook_id = gradebook
                student?.group_id = group.group_id
            }
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
        let manager = RequestManager<GroupStructure>()
        var groupForCurrentStudent: GroupStructure?
        manager.getEntity(byId: byId, entityStructure: Entities.Group, returnResults: { (groupInstance, error) in
            if groupInstance != nil {
                groupForCurrentStudent = groupInstance!
            }
            self.selectedGroupForStudent = groupInstance
            self.groupButton.setTitle(groupForCurrentStudent!.group_name, for: .normal)
        })
    }
}
