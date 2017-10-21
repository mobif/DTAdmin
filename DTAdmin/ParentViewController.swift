//
//  ParentViewController.swift
//  DTAdmin
//
//  Created by mac6 on 10/21/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit
import Foundation

class ParentViewController: UIViewController {
    
    var backGroundView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showAllert(title: String?, message: String?, completionHandler: @escaping () -> Void?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            completionHandler()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func startActivity() {
        DispatchQueue.main.async {
            self.backGroundView?.removeFromSuperview()
            self.backGroundView = UIView(frame: self.view.frame)
            self.backGroundView?.backgroundColor = UIColor.black
            self.backGroundView?.alpha = 0.5
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.activityIndicator?.center = self.navigationController?.view.center ?? self.view.center
            if !self.backGroundView!.subviews.contains(self.activityIndicator!) {
                self.backGroundView?.addSubview(self.activityIndicator!)
            }
            self.activityIndicator?.startAnimating()
            
            let navigationView = self.navigationController?.view
            let view = navigationView != nil ? navigationView! : self.view!
            
            view.addSubview(self.backGroundView!)
            UIView.animate(withDuration: 0.3, animations: {
                view.layoutIfNeeded()
            })
            self.backGroundView!.clipsToBounds = true
        }
    }
    
    func stopActivity() {
        DispatchQueue.main.async {
            self.backGroundView?.removeFromSuperview()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //            if self.view.frame.origin.y == 0{
        //                self.view.frame.origin.y -= keyboardSize.height
        //            }
        //        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //            if self.view.frame.origin.y != 0{
        //                self.view.frame.origin.y += keyboardSize.height
        //            }
        //        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.backGroundView?.frame = self.view.frame
        self.activityIndicator?.center = self.navigationController?.view.center ?? self.view.center
    }
}
