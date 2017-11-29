//
//  FacultyInfoViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/28/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class FacultyInfoViewController: UIViewController {

    @IBOutlet weak var facultyIdTextField: UILabel!
    @IBOutlet weak var facultyNameTextField: UILabel!
    @IBOutlet weak var facultyDescriptionTextField: UILabel!


    var facultyInstance: FacultyStructure? {
        didSet {
            self.view.layoutIfNeeded()
            guard let facultyInstance = facultyInstance else { return }
            facultyIdTextField.text = facultyInstance.id
            facultyNameTextField.text = facultyInstance.name
            facultyDescriptionTextField.text = facultyInstance.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Info", comment: "title of SpecialityInfoViewController")
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
