//
//  DetailSubjectViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/24/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class DetailSubjectViewController: UIViewController {
    
    @IBOutlet weak var subjectNameTextField: UILabel!
    
    @IBOutlet weak var subjectDescriptionTextField: UILabel!
    
    var subject: Subject? {
        didSet {
            guard let subject = subject else { return }
            self.view.layoutIfNeeded()
            self.subjectNameTextField.text = subject.id + " " + subject.name 
            self.subjectDescriptionTextField.text = subject.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func timeTableButtonTapped(_ sender: Any) {
        let timeTableStoryboard = UIStoryboard.stoyboard(by: .timeTable)
        guard let timeTableViewController = timeTableStoryboard.instantiateViewController(withIdentifier: "TimeTableListViewController") as? TimeTableListViewController else { return }
        timeTableViewController.subjectID = Int(self.subject?.id ?? "")
        self.navigationController?.pushViewController(timeTableViewController, animated: true)
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
