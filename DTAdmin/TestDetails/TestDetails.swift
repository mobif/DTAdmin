//
//  TestDetails.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/28/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

enum TestDetails: String {
    case id = "id"
    case testId = "test_id"
    case level = "level"
    case tasks = "tasks"
    case rate = "rate"
    
    static let allValues: [TestDetails] = [level, tasks, rate]
}

enum Numbers: Int {
    case maxLevel = 10
    case maxRate = 100
    case minDetail = 0
}
