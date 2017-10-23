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
    var studentList = [StudentGetStructure]()
    var filtered = false
    var filteredList: [StudentGetStructure]{
        if filtered {
            guard let searchString = searchBar.text else {return studentList}
            return studentList.filter({
                ($0.studentName.contains(searchString) || $0.studentFname.contains(searchString)) })
        } else {
            return studentList
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var studentTable: UITableView!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationItem = self.navigationItem
        
        navigationItem.title = NSLocalizedString("Students", comment: "List all students")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addNewStudent))
        navigationItem.rightBarButtonItem = doneItem
        if user != nil {
            userName.text = user?.username
        }
        studentTable.delegate = self
        studentTable.dataSource = self
        searchBar.delegate = self
        updateTable()
    }
    
    func updateTable(){
        let manager = RequestManager<StudentGetStructure>()
        manager.getEntityList(byStructure: Entities.Student, returnResults: { (students, error) in
            if error == nil,
                let students = students {
                self.studentList = students
            }
            self.studentTable.reloadData()
        })
    }
    
    @objc func addNewStudent(){
        guard let editStudentViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "EditStudentViewController") as? EditStudentViewController else {return}
        editStudentViewController.titleViewController = NSLocalizedString("New Student", comment: "Create new Student")
        editStudentViewController.resultModification = { (studentReturn, isNew) in
            if isNew {
                self.studentList.append(studentReturn)
                self.studentTable.reloadData()
            }
        }
        self.navigationController?.pushViewController(editStudentViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInstance = filtered ? filteredList[indexPath.row] : studentList[indexPath.row]
        
        guard let editStudentViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "EditStudentViewController") as? EditStudentViewController else {return}
        editStudentViewController.titleViewController = NSLocalizedString("Edit", comment: "Edit account of student")
        editStudentViewController.studentLoaded = studentInstance
        editStudentViewController.resultModification = { (studentReturn, isNew) in
            if !isNew {
                if self.filtered {
                    guard let indexOfStudent = self.getIndex(byId: studentReturn.userId) else {
                        self.showWarningMsg(NSLocalizedString("User not found!", comment: "Updated user not found!"))
                        return
                    }
                    self.studentList[indexOfStudent] = studentReturn
                } else {
                    self.studentList[indexPath.row] = studentReturn
                }
                self.studentTable.reloadData()
            }
        }
        navigationController?.pushViewController(editStudentViewController, animated: true)
    }
    
    func getIndex(byId: String) -> Int? {
        let index = studentList.index(where: { $0.userId == byId } )
        return index
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filtered = (searchBar.text!.count > 0)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = searchText.count > 0
        studentTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellWraped = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as? StudentsTableViewCell
        guard let cell = cellWraped else { return UITableViewCell() }
        cell.name.text = filteredList[indexPath.row].studentName
        cell.fName.text = filteredList[indexPath.row].studentFname
        cell.sName.text = filteredList[indexPath.row].studentSurname
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Del") { action, index in
            let postMan = RequestManager<StudentPostStructure>()
            let studentId = self.filteredList[indexPath.row].userId
            postMan.deleteEntity(byId: studentId, entityStructure: Entities.Student, returnResults: { error in
                if let error = error {
                    self.showWarningMsg(error)
                } else {
                    if self.filtered {
                        guard let indexOfStudent = self.getIndex(byId: studentId) else {
                            self.showWarningMsg(NSLocalizedString("UserID not found!", comment: "UserID not found in list!"))
                            return
                        }
                        self.studentList.remove(at: indexOfStudent)
                    } else {
                        self.studentList.remove(at: indexPath.row)
                    }
                    self.studentTable.reloadData()
                }
            })
        }
        return [delete]
    }

}
extension UIViewController {
    func showWarningMsg(_ textMsg: String) {
        let alert = UIAlertController(title: "Error!", message: textMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
