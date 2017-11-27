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
            guard let specialityInstance = specialityInstance else { return }
            specialityIdTextField.text = specialityInstance.id
            specialityCodeTextField.text = specialityInstance.code
            specialityNameTextField.text = specialityInstance.name
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
