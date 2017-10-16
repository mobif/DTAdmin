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
            guard let studentVC = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "StudentViewController") as? StudentViewController else {
                self.showWarningMsg("ViewController with id: students not found")
                    return
            }
            guard let cookieValue = cookie else {return}
            guard let userInstance = user else {return}
            studentVC.user = userInstance
            studentVC.cookie = cookieValue
            let navigationController = UINavigationController(rootViewController: studentVC)
//            navigationController.pushViewController(studentVC, animated: true)
//            let navigationController = UIStoryboard(name: "Student", bundle: nil).
//            navigationController?.pushViewController(studentVC, animated: true)
            self.present(navigationController, animated: true, completion: nil)
        })
    }
    private func showWarningMsg(_ textMsg: String) {
        let alert = UIAlertController(title: "Error!", message: textMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
