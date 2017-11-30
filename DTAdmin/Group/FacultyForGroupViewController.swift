//
//  FacultyViewController.swift
//  DTAdmin
//
//  Created by Admin on 21.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class FacultyForGroupViewController: ParentViewController {
    
    @IBOutlet weak var facultyTableView: UITableView!
    
    /**
     This clousure perfoms by transmitting the object to be selected by the user to other controllers
     */
    var selectFaculty: ((FacultyStructure) -> ())?
    var faculties = [FacultyStructure]() {
        didSet {
            DispatchQueue.main.async {
                self.facultyTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Faculties", comment: "Title for Faculties table view")
        facultyTableView.delegate = self
        facultyTableView.dataSource = self
        DataManager.shared.getList(byEntity: .faculty){ (faculties, error) in
            if let error = error {
                self.showAllert(error: error, completionHandler: nil)
            } else {
                guard let faculties = faculties as? [FacultyStructure] else {return}
                self.faculties = faculties
            }
        }
    }
}

//MARK: table view delegate
extension FacultyForGroupViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFaculty = self.faculties[indexPath.row]
        guard let selectFaculty = self.selectFaculty else { return }
        selectFaculty(selectedFaculty)
        navigationController?.popViewController(animated: true)
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
