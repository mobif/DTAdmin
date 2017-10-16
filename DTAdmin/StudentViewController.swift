//
//  StudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
   
    var user: UserStructure?
    var cookie: HTTPCookie?
    var studentList = [StudentStructure]()
    var filtered = false
    var filteredList: [StudentStructure]{
        if filtered {
            guard let searchString = searchBar.text else {return studentList}
            return studentList.filter({ $0.student_name.contains(searchString)})
        } else {
            return studentList
        }
    }
    
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var studentTable: UITableView!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user != nil {
            userName.text = user?.username
        }
        studentTable.delegate = self
        studentTable.dataSource = self
        searchBar.delegate = self
        let manager = RequestManager<StudentStructure>()
        manager.getEntityList(byStructure: Entities.Student, returnResults: { (students, error) in
            if error == nil,
                students != nil{
                self.studentList = students!
            }
            self.studentTable.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filtered = (searchBar.text!.count > 0)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = searchText.count > 0
        studentTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
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
