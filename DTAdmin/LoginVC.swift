//
//  LoginVC.swift
//  DTAdmin
//
//  Created by Admin on 18.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBAction func loginTapped(_ sender: Any) {
        HTTPService.login(){(result:HTTPURLResponse) in
            if result.statusCode == 200 {
//                let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupVC") as! UIViewController
//                self.navigationController?.pushViewController(tableViewController, animated: true)
                print("true")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
