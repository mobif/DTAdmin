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
    var selectedItem = Int()
    var task = Int()
    var result: ((Int) -> ())?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Select \(dataModel.details[detail])", comment: "title of NumbersViewController")
        guard let max = dataModel.max else { return }
        switch detail {
        case 0:
            self.currentArray = dataModel.getFilteredArrayForLevels(firstArray: dataModel.createArray(
                max: Numbers.maxLevel.rawValue), secondArray: dataModel.levelArrayForFiltering)
        case 1:
            if dataModel.taskArrayForFiltering.reduce(0, +) == dataModel.max {
                let task1 = dataModel.detailArray[1].number
                guard let taskInt = Int(task1) else { return }
                if taskInt == 1 {
                    task = 1
                } else {
                    task = taskInt - 1
                }
            } else {
                let task2 = max - dataModel.taskArrayForFiltering.reduce(0, +)
                task = task2
            }
            self.currentArray = dataModel.createArray(max: task)
        case 2:
            self.currentArray = dataModel.createArray(max: Numbers.maxRate.rawValue)
        default:
            return
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            if let result = self.result {
                result(self.selectedItem)
            }
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
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedItem = currentArray[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }

}
