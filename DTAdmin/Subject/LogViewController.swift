//
//  LogViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/20/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let queryService = QueryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        guard let username = loginTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if !username.isEmpty, !password.isEmpty {
            doLogin(username, password)
        } else {
            return showMessage(message: NSLocalizedString("Please, enter all fields!", comment: "Message for user"))
        }
    }
    
    func doLogin(_ user: String, _ psw: String) {
        queryService.postRequests(parameters : ["username": user, "password": psw], sufix: "login/index", completion: {(array: [Subject]?, code: Int, error: String) in
                print(code)
                DispatchQueue.main.async {
                    if code == 200 {
                        if let wayToShowRecords = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "SubjectTableViewController") as? SubjectTableViewController {
                            self.navigationController?.pushViewController(wayToShowRecords, animated: true)
                        }
                    } else {
                        self.showMessage(message: NSLocalizedString("Invalid login or password", comment: "Message for user") )
                    }
                }
            })
    }
    
}
