//
//  DetailSubjectViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/24/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class DetailSubjectViewController: UIViewController {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    
    @IBOutlet weak var subjectDescriptionLabel: UILabel!
    
    var subject: SubjectStructure? {
        didSet {
            guard let subject = subject else { return }
            self.view.layoutIfNeeded()
            self.subjectNameLabel.text = subject.name
            self.subjectDescriptionLabel.text = subject.description
        }
    }

    @IBAction func showTestsForSubject(_ sender: UIButton) {
        guard let wayToShowTestsForSubject = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "TestForSubjectTableViewController") as? TestsForSubjectTableViewController else { return }
            wayToShowTestsForSubject.subjectId = self.subject?.id
            self.navigationController?.pushViewController(wayToShowTestsForSubject, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail subject"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func timeTableButtonTapped(_ sender: Any) {
        let timeTableStoryboard = UIStoryboard.storyboard(by: .TimeTable)
        guard let timeTableViewController = timeTableStoryboard.instantiateViewController(withIdentifier: "TimeTableListViewController") as? TimeTableListViewController else { return }
        timeTableViewController.subjectID = Int(self.subject?.id ?? "")
        self.navigationController?.pushViewController(timeTableViewController, animated: true)
    }

}
