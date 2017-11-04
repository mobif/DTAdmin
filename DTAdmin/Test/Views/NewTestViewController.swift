//
//  NewTestViewController.swift
//  DTAdmin
//
//  Created by Anastasia Kinelska on 11/2/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class NewTestViewController: UIViewController {

    @IBOutlet weak var isEnabledLabel: UILabel!
    @IBOutlet weak var testNameTextField: UITextField!
    @IBOutlet weak var timeForTestTextField: UITextField!
    @IBOutlet weak var attemptsTextField: UITextField!
    @IBOutlet weak var questionsTextField: UITextField!
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if (sender.isOn == true) {
            isEnabledLabel.text = "Is Enabled"
        } else {
            isEnabledLabel.text = "Is Disabled"
        }
    }
    
    
    var testInstance: TestStructure? {
        didSet {
            self.view.layoutIfNeeded()
            testNameTextField.text = testInstance?.name
            timeForTestTextField.text = testInstance?.timeForTest
            attemptsTextField.text = testInstance?.timeForTest
            questionsTextField.text = testInstance?.tasks
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
