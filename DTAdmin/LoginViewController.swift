//
//  LoginViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = signInButton.frame.height / 3
        signInButton.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func tapSignIn(_ sender: UIButton) {
        let login = RequestManager<UserStructure>()
        guard let loginNameText = loginName.text else {return}
        guard let passwordText = password.text else {return}
        login.getLoginData(for: loginNameText, password: passwordText, returnResults: {
            (user, cookie, error) in
            if error != nil {
                self.showWarningMsg(error!)
                return
            }
            guard let studentViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "StudentViewController") as? StudentViewController else {
                self.showWarningMsg("ViewController with id: students not found")
                    return
            }
            let navigationController = UINavigationController(rootViewController: studentViewController)
            self.present(navigationController, animated: true, completion: nil)
        })
    }
}
