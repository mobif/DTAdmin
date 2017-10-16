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
    var titleViewController: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if student != nil {
            name.text = student!.student_name
            fName.text = student!.student_fname
            sName.text = student!.student_surname
            guard let groupName = getGroup(byId: student!.group_id) else { return }
            groupButton.setTitle(groupName.group_name, for: .normal)
        }
    
        if titleViewController != nil {
            navigationItem.title = titleViewController
        }
        
        // Do any additional setup after loading the view.
    }
    func getGroup(byId: String) -> GroupStructure?{
        let manager = RequestManager<GroupStructure>()
        var group: GroupStructure?
        manager.getEntity(byId: byId, entityStructure: Entities.Group, returnResults: { (groupInstance, error) in
            if groupInstance != nil {
                group = groupInstance!
            }
            self.groupButton.setTitle(group!.group_name, for: .normal)
        })
        return group
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
