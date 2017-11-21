//
//  NumbersViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/17/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class NumbersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let dataModel = DataModel.dataModel
    var currentArray = [Int]()
    var detail = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select test \(dataModel.testDetails[detail])"
        switch detail {
        case 0:
            self.currentArray = dataModel.createArray(max: 10)
        case 1:
            self.currentArray = dataModel.createArray(max: dataModel.max)
        case 2:
            self.currentArray = dataModel.createArray(max: 100)
        default:
            return
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            print("move")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = tableView.dequeueReusableCell(withIdentifier: "selectDetailCell",
                                                          for: indexPath) as? SelectDetailTableViewCell
        guard let cell = prototypeCell else { return UITableViewCell() }
        let item = currentArray[indexPath.row]
        cell.numberForTestDetailsLabel.text = String(item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //checkmark
    }

}
