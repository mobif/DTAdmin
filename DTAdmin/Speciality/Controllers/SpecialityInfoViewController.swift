//
//  SpecialityInfoViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SpecialityInfoViewController: UIViewController {

    @IBOutlet weak var specialityIdTextField: UILabel!
    @IBOutlet weak var specialityCodeTextField: UILabel!
    @IBOutlet weak var specialityNameTextField: UILabel!
    
    
    var specialityInstance: SpecialityStructure? {
        didSet {
            self.view.layoutIfNeeded()
            specialityIdTextField.text = specialityInstance?.id
            specialityCodeTextField.text = specialityInstance?.code
            specialityNameTextField.text = specialityInstance?.name
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
