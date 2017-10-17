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
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var sName: UITextField!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var numberBook: UITextField!
    var titleViewController: String?
    var selectedGroup: GroupStructure?
    override func viewDidLoad() {
        super.viewDidLoad()
        if student != nil {
            name.text = student!.student_name
            fName.text = student!.student_fname
            sName.text = student!.student_surname
            password.text = student!.plain_password
            numberBook.text = student!.gradebook_id
            getGroupFromAPI(byId: student!.group_id)
        } else {
            let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.saveStudent))
            navigationItem.rightBarButtonItem = doneItem
        }
        if titleViewController != nil {
            navigationItem.title = titleViewController
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func saveStudent(){
        let postMan = PostManager<StudentStructure>()
        if cheakFields(){
            postMan.insertEntity(entity: student!, entityStructure: Entities.Student, returnResults: { error in
                if error != nil {
                    print(error!)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func cheakFields() -> Bool {
        guard let name = name.text else { return false}
        guard let sname = sName.text else { return false}
        guard let fname = fName.text else { return false}
        guard let gradebook = numberBook.text else { return false}
        guard let pass = password.text else { return false}
        guard let group = selectedGroup else { return false}
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
        guard let groupsVC = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "GroupsTableViewController") as? GroupsTableViewController else {return}
        groupsVC.titleViewController = "Groups"
        groupsVC.selecectedGroup = {
            group in
            self.selectedGroup = group
            self.groupButton.setTitle(group.group_name, for: .normal)
        }
        self.navigationController?.pushViewController(groupsVC, animated: true)
    }
    func getGroupFromAPI(byId: String){
        let manager = RequestManager<GroupStructure>()
        var group: GroupStructure?
        manager.getEntity(byId: byId, entityStructure: Entities.Group, returnResults: { (groupInstance, error) in
            if groupInstance != nil {
                group = groupInstance!
            }
            self.selectedGroup = groupInstance
            self.groupButton.setTitle(group!.group_name, for: .normal)
        })
    }
}
