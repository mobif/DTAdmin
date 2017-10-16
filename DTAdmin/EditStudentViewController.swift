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
            getGroup(byId: student!.group_id)
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
    func getGroup(byId: String){
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
