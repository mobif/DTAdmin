//
//  TestDetailInfoViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/29/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailInfoViewController: UIViewController {

    @IBOutlet weak var detailsIdTextField: UILabel!
    @IBOutlet weak var testIdTextField: UILabel!
    @IBOutlet weak var levelTextField: UILabel!
    @IBOutlet weak var taskTextField: UILabel!
    @IBOutlet weak var rateTextField: UILabel!


    var testDetailInstance: TestDetailStructure? {
        didSet {
            self.view.layoutIfNeeded()
            guard let testDetailInstance = testDetailInstance else { return }
            detailsIdTextField.text = testDetailInstance.id
            testIdTextField.text = testDetailInstance.testId
            levelTextField.text = testDetailInstance.level
            taskTextField.text = testDetailInstance.tasks
            rateTextField.text = testDetailInstance.rate
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Info", comment: "title of TestDetailInfoViewController")
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }



}
