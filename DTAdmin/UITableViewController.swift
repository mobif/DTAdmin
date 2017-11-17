//
//  UITableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

extension UITableViewController {

    var activityIndicatorTag: Int { return 1 }

    func startActivityIndicator() {
        let location = self.view.center

        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.center = location
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }

    func stopActivityIndicator() {

        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }

    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString (string: "Pull to refresh")
        refreshControl.tintColor = UIColor(red: 1.0, green: 0.21, blue: 0.55, alpha: 0.5)

        return refreshControl
    }

    func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
