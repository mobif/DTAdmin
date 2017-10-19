//
//  StudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var studentList = [StudentGetStructure]()
    var filtered = false
    var filteredList: [StudentGetStructure]{
        if filtered {
            guard let searchString = searchBar.text else { return studentList }
            return studentList.filter({
                ($0.student_name.contains(searchString) || $0.student_fname.contains(searchString)) })
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
        navigationItem.title = "Students"
        let newItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addNewStudent))
        navigationItem.rightBarButtonItem = newItem
        studentTable.delegate = self
        studentTable.dataSource = self
        searchBar.delegate = self
        updateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTable()
    }
    
    func updateTable(){
        let manager = RequestManager<StudentGetStructure>()
        manager.getEntityList(byStructure: Entities.Student, returnResults: { (students, error) in
            if error == nil,
                let loadedStudents = students {
                self.studentList = loadedStudents
            } else {
                guard let errorMessage = error else { return }
                self.showWarningMsg(errorMessage)
            }
            self.studentTable.reloadData()
        })
    }
    
    @objc func addNewStudent(){
        guard let editStudentViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "EditStudentViewController") as? EditStudentViewController else { return }
        editStudentViewController.titleViewController = "New Student"
        self.navigationController?.pushViewController(editStudentViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInstance = filtered ? filteredList[indexPath.row] : studentList[indexPath.row]
        
        guard let editStudentViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "EditStudentViewController") as? EditStudentViewController else { return }
        editStudentViewController.titleViewController = "Edit"
        editStudentViewController.studentLoaded = studentInstance
        navigationController?.pushViewController(editStudentViewController, animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        filtered = (searchText.count > 0)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as? StudentsTableViewCell
        if let studentsCell = cell {
            studentsCell.name.text = filteredList[indexPath.row].student_name
            studentsCell.fName.text = filteredList[indexPath.row].student_fname
            studentsCell.sName.text = filteredList[indexPath.row].student_surname
            return studentsCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Del") { action, index in
            let studentId = self.filteredList[indexPath.row].user_id
            RequestManager<StudentPostStructure>().deleteEntity(byId: studentId, entityStructure: Entities.Student, returnResults: { error in
                if let error = error {
                    self.showWarningMsg(error)
                } else {
                    self.updateTable()
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
    func showWarningMsg(_ textMsg: String?) {
        if let unwrapedText = textMsg {
            showWarningMsg(unwrapedText)
        }
    }
}
