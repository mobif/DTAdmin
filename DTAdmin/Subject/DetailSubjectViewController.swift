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
    
    var subject: Subject? {
        didSet {
            guard let subject = subject else { return }
            self.view.layoutIfNeeded()
            self.subjectNameLabel.text = subject.id + " " + subject.name
            self.subjectDescriptionLabel.text = subject.description
        }
    }

    @IBAction func showTestsForSubject(_ sender: UIButton) {
        if let wayToShowTestsForSubject = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "TestForSubjectTableViewController") as? TestsForSubjectTableViewController {
            wayToShowTestsForSubject.subjectId = self.subject?.id
            self.navigationController?.pushViewController(wayToShowTestsForSubject, animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
