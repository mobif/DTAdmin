//
//  getTestDetailsViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/17/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class GetTestDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let dataModel = DataModel.dataModel

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.testDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = tableView.dequeueReusableCell(withIdentifier: "selectDetailsCell",
                                                          for: indexPath) as? SelectDetailsTableViewCell
        guard let cell = prototypeCell else { return UITableViewCell() }
        let item = dataModel.testDetails[indexPath.row]
        cell.testDetailNameLabel.text = item
        cell.numberOfTestDetailLabel.text = "select"
        cell.numberOfTestDetailLabel.alpha = 0.5
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let numbersViewController = UIStoryboard(name: "TestDetails",
                                                              bundle: nil).instantiateViewController(
        withIdentifier: "NumbersViewController") as? NumbersViewController else { return }
        numbersViewController.detail = indexPath.row
        self.navigationController?.pushViewController(numbersViewController, animated: true)
    }

    
}
