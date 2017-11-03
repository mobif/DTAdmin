//
//  UIViewController.swift
//  DTAdmin
//
//  Created by mac6 on 11/3/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

extension UIViewController {
    func showLoginScreen() {
        StoreHelper.logout()
        if let rootNavController = self.navigationController?.navigationController as? RootNavController {
            rootNavController.popToRootViewController(animated: true)
        } else if let rootNavController = self.navigationController as? RootNavController {
            rootNavController.popToRootViewController(animated: true)
        }
    }
}
