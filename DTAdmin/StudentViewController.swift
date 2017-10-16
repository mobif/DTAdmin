//
//  StudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {

    var user: UserStructure?
    var cookie: HTTPCookie?
    var studentList = [StudentStructure]()
    
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            userName.text = user?.username
        }
        let manager = RequestManager<StudentStructure>()
        manager.getEntityList(byStructure: Entities.Student, returnResults: { _ in
            
        })
//        manager.getEntityList<StudentStructure>(byStructure: Entities.Student, returnResults: {array in
//
//        })
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
