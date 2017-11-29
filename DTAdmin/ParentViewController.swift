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
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showAllert(title: String?, message: String?, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            completionHandler?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    func showAllert(error: ErrorData?, completionHandler: (() -> Void)?) {
        let errorMsg = (error?.message ?? "") + (error?.descriptionError ?? "")
        let alertController = UIAlertController(title: error?.type.rawValue, message: errorMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            completionHandler?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    func showWarningMsg(_ text: String) {
        showAllert(title: "Warning", message: text, completionHandler: nil)
    }
    
    func startActivity() {
        DispatchQueue.main.async {
            self.backGroundView?.removeFromSuperview()
            self.backGroundView = UIView(frame: self.view.frame)
            self.backGroundView?.backgroundColor = UIColor.black
            self.backGroundView?.alpha = 0.5
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.activityIndicator?.center = self.navigationController?.view.center ?? self.view.center
            if let backgroundView = self.backGroundView, let activitiIndicator = self.activityIndicator {
                if !backgroundView.subviews.contains(activitiIndicator) {
                    backgroundView.addSubview(activitiIndicator)
                }
                activitiIndicator.startAnimating()
                if let navigationView = self.navigationController?.view {
                    navigationView.addSubview(backgroundView)
                    UIView.animate(withDuration: 0.3, animations: {
                        navigationView.layoutIfNeeded()
                    })
                } else {
                    self.view.addSubview(backgroundView)
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
                backgroundView.clipsToBounds = true
            }
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
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.backGroundView?.frame = self.view.frame
        self.activityIndicator?.center = self.navigationController?.view.center ?? self.view.center
    }
}
