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
        self.performSegue(withIdentifier: "toLogin", sender: self)

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
