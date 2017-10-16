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
            groupButton.setTitle(student!.group_id, for: .normal) 
        }
        
        let navigationItem = self.navigationItem
        if titleViewController != nil {
            navigationItem.title = titleViewController
        }
        
        // Do any additional setup after loading the view.
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
