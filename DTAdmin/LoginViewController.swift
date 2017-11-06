//
//  LoginViewController.swift
//  DTAdmin
//
//  Created by mac6 on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class LoginViewController: ParentViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTitleLabel.text = "DTAdmin"
        self.loginTextField.placeholder = "login"
        self.passwordTextField.placeholder = "password"
        self.passwordTextField.isSecureTextEntry = true
        self.loginButton.setTitle("Login", for: .normal)
        
        //test data
        self.loginTextField.text = "admin"
        self.passwordTextField.text = "dtapi_admin"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.startActivity()
        CommonNetworkManager.shared().logIn(username: self.loginTextField.text ?? "", password: self.passwordTextField.text ?? "") { (user, error) in
            self.stopActivity()
            if let error = error {
                print(error.localizedDescription)
            } else {
                StoreHelper.saveUser(user: user)
                DispatchQueue.main.async {
                    if let rootNavController = self.navigationController as? RootNavController {
                        rootNavController.moveToMain()
                    }
                }
            }
        }
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
