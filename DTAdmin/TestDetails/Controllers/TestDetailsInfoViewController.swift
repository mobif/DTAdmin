//
//  testDetailsInfoViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailsInfoViewController: UIViewController {

    @IBOutlet weak var testDetailsIdTextField: UILabel!
    @IBOutlet weak var testDetailsTestIdTextField: UILabel!
    @IBOutlet weak var testDetailsLevelTextField: UILabel!
    @IBOutlet weak var testDetailsTaskTextField: UILabel!
    @IBOutlet weak var testDetailsRateTextField: UILabel!
    
    var testDetailsInstance: TestDetailStructure? {
        didSet {
            self.view.layoutIfNeeded()
            testDetailsIdTextField.text = testDetailsInstance?.id
            testDetailsTestIdTextField.text = testDetailsInstance?.testId
            testDetailsLevelTextField.text = testDetailsInstance?.level
            testDetailsTaskTextField.text = testDetailsInstance?.tasks
            testDetailsRateTextField.text = testDetailsInstance?.rate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info"
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
