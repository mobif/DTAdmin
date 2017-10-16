//
//  StudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var user: UserStructure?
    var cookie: HTTPCookie?
    var studentList = [StudentStructure]()
    var filtered = false
    var filteredList: [StudentStructure]{
        if filtered {
            return studentList.filter({ $0.student_name.contains("a")})
        } else {
            return studentList
        }
    }
    
   
    @IBOutlet weak var studentTable: UITableView!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user != nil {
            userName.text = user?.username
        }
        studentTable.delegate = self
        let manager = RequestManager<StudentStructure>()
        manager.getEntityList(byStructure: Entities.Student, returnResults: { (students, error) in
            if error == nil,
                students != nil{
                self.studentList = students!
            }
            self.studentTable.reloadData()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentsTableViewCell
        cell.name.text = filteredList[indexPath.row].student_name
        cell.fName.text = filteredList[indexPath.row].student_fname
        cell.sName.text = filteredList[indexPath.row].student_surname
        return cell
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
