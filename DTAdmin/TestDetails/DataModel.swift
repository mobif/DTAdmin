//
//  DataModel.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/12/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class DataModel: NSObject {

    static let dataModel = DataModel()
    var testDetailArray = [TestDetailStructure]()
    var levelArrayForFiltering = [Int]()
    var taskArrayForFiltering = [Int]()
    var details = ["level", "task", "rate"]
    var detailArray = [DetailStructure]()
    let max = 10

    func createArray(max: Int) -> [Int] {
        var array = [Int]()
        for i in 1...max {
            array.append(i)
        }
        return array
    }
    
    func currentDataForSelecting() {
        levelArrayForFiltering = []
        taskArrayForFiltering = []
        for i in testDetailArray {
            guard let levels = Int(i.level) else { return }
            levelArrayForFiltering.append(levels)
            guard let tasks = Int(i.tasks) else { return }
            taskArrayForFiltering.append(tasks)
        }
    }
    
    func getFilteredArrayForLevels(firstArray: [Int], secondArray: [Int]) -> [Int] {
        var filtered = firstArray
        for item in secondArray {
            if let index = filtered.index(of: item) {
                filtered.remove(at: index)
            }
        }
        return filtered
    }
}

class DetailStructure {

    var detail: String
    var number: String

    init(detail: String, number: String) {
        self.detail = detail
        self.number = number
    }
}
