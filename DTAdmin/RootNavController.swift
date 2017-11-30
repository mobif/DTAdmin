//
//  RootNavController.swift
//  DTAdmin
//
//  Created by mac6 on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class RootNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if StoreHelper.isLoggedUser(),
            let logedInUserName: String = StoreHelper.getLoggedUser().userName {
            DataManager.shared.checkUser(name: logedInUserName) {
                error in
                if error != nil {
                    self.showLoginScreen()
                } else {
                    self.moveToMain()
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToMain() {
        self.performSegue(withIdentifier: "toMain", sender: self)
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
