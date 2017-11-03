//
//  FacultyViewController.swift
//  DTAdmin
//
//  Created by Admin on 21.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class FacultyForGroupViewController: UIViewController {
    
    @IBOutlet weak var facultyTableView: UITableView!
    
    var selectFaculty: ((Faculty) -> ())?
    var faculties = [Faculty]() {
        didSet {
            DispatchQueue.main.async {
                self.facultyTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Faculties"
        facultyTableView.delegate = self
        facultyTableView.dataSource = self
        HTTPService.getAllData(entityName: "faculty") {
            (facultyJSON:[[String:String]],facultyResponce) in
            let faculties = facultyJSON.flatMap{Faculty(dictionary: $0)}
            self.faculties = faculties
        }
    }
}

extension FacultyForGroupViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFaculty = self.faculties[indexPath.row]
        self.selectFaculty!(selectedFaculty)
        _ = navigationController?.popViewController(animated: true)
    }
}

//MARK: table view data source
extension FacultyForGroupViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = facultyTableView.dequeueReusableCell(withIdentifier: "FacultyCell", for: indexPath)
        cell.textLabel?.text = faculties[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculties.count
    }
}
