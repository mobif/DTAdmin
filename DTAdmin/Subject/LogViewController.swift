//
//  LogViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/20/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    let queryService = QueryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func showMessage(message: String){
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        let username = loginField.text
        let password = passwordField.text
        
        if let user = username, let psw = password {
            doLogin(user, psw)
        } else {
            return showMessage(message: NSLocalizedString("Please, enter all fields!", comment: "Message for user") )
        }
    }
    
    func doLogin(_ user:String, _ psw:String)
    {
        
        queryService.postRequests(parameters : ["username" : user, "password" : psw], sufix : "login/index", completion: {(results:Int?) in
            
            if let code = results {
                print(code)
                DispatchQueue.main.async {
                    if code == 200 {
                        let storyboard = UIStoryboard(name: "Subjects", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SubjectTableVC") as? SubjectTableViewController
                        self.navigationController?.pushViewController(vc!,animated: true)
                    } else {
                        self.showMessage(message: NSLocalizedString("Invalid login or password", comment: "Message for user") )
                    }
                }
            }
        })
        
    }

}
