//
//  LoginViewController.swift
//  DTAdmin
//
//  Created by Admin on 19.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func loginButtoTapped(_ sender: Any) {
        HTTPService.login(){(result:HTTPURLResponse) in
            if result.statusCode == 200 {
                let storyBoard: UIStoryboard = UIStoryboard(name: "GroupSB", bundle: nil)
                let groupViewController = storyBoard.instantiateViewController(withIdentifier: "GroupVC") as! GroupViewController
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(groupViewController, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
