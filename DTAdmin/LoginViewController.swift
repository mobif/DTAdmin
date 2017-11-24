//
//  LoginViewController.swift
//  DTAdmin
//
//  Created by mac6 on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class LoginViewController: ParentViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var cloud1ImageView: UIImageView!
    @IBOutlet weak var cloud2ImageView: UIImageView!
    @IBOutlet weak var tree1ImageView: UIImageView!
    @IBOutlet weak var tree2ImageView: UIImageView!

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.topTitleLabel.center.y -= view.bounds.width
        self.loginTextField.center.x -= view.bounds.width
        self.passwordTextField.center.x -= view.bounds.width
        self.cloud1ImageView.alpha = 0.0
        self.cloud2ImageView.alpha = 0.0
        self.buildingImageView.alpha = 0.0
        self.tree1ImageView.alpha = 0.0
        self.tree2ImageView.alpha = 0.0

        UIView.animate(withDuration: 2.0, animations: {
            self.topTitleLabel.center.y += self.view.bounds.width
        })

        UIView.animate(withDuration: 1.5, delay: 0.5,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn, animations: {
                        self.loginTextField.center.x += self.view.bounds.width
        }, completion: nil)

        UIView.animate(withDuration: 1.5, delay: 0.5,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseOut, animations: {
                        self.passwordTextField.center.x += self.view.bounds.width
        }, completion: nil)

        loginButton.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 2.0,
                                   options: [],
                                   animations: {
                                    self.loginButton.alpha = 1.0
        }, completion: nil)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [], animations: {
            self.buildingImageView.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 0.8, options: [], animations: {
            self.tree1ImageView.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            self.cloud1ImageView.alpha = 1.0
            self.tree2ImageView.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 1.2, options: [], animations: {
            self.cloud2ImageView.alpha = 1.0
        }, completion: nil)
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
