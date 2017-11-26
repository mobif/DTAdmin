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

    func showMessage(message: String, title: String = "Warning") {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /**
     Making animation for tables view cell
     - Parameter cell: getting cell for current table view
     */
    func animatedCell(for cell: UITableViewCell) {
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * Double.pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
        cell.layer.transform = rotationTransform

        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut, animations: {
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
}
