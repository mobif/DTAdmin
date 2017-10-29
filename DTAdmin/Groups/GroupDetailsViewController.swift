//
//  GroupDetailsViewController.swift
//  DTAdmin
//
//  Created by Admin on 29.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController {
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var facultyNameLabel: UILabel!
    
    @IBOutlet weak var facultyDescriptionLabel: UILabel!
    
    @IBOutlet weak var specialityNameLabel: UILabel!
    
    @IBOutlet weak var specialityCodeLabel: UILabel!
    
    @IBAction func getStudentsByGroupTapped(_ sender: Any) {
    }
    @IBAction func getTimeTableByGroupTapped(_ sender: Any) {
    }
    @IBAction func getResultsByGroupTapped(_ sender: Any) {
    }
    
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        getDetailsByGroup()
    }

    func getDetailsByGroup() {
        guard let group = group else { return }
        self.groupNameLabel.text = group.name
        HTTPService.getData(entityName: "faculty", id: group.facultyId) {
            (facultyJSON,facultyResponce) in
            if facultyResponce.statusCode == 200 {
                let faculty = facultyJSON.flatMap{Faculty(dictionary: $0)}
                if faculty.first != nil {
                    DispatchQueue.main.async {
                    self.facultyNameLabel.text = faculty.first?.name
                    self.facultyDescriptionLabel.text = faculty.first?.description
                    }
                }
            }
        }
        HTTPService.getData(entityName: "speciality", id: group.specialityId) {
            (specialityJSON,specialityResponce) in
            if specialityResponce.statusCode == 200 {
                let speciality = specialityJSON.flatMap{Speciality(dictionary: $0)}
                if speciality.first != nil {
                    DispatchQueue.main.async {
                    self.specialityNameLabel.text = speciality.first?.name
                    self.specialityCodeLabel.text = speciality.first?.code
                    }
                }
            }
        }
    }

}
