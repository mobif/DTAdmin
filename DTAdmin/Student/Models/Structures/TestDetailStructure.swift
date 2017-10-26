//
//  TestDetailStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
class TestDetailStructure {
    var id: String?
    var testId: String
    var level: String
    var tasks: String
    var rate: String
    init?(dictionary: [String: Any]) {
        id = dictionary["id"] as? String
        guard let testId = dictionary["test_id"] as? String,
        let level = dictionary["level"] as? String,
        let tasks = dictionary["tasks"] as? String,
        let rate = dictionary["rate"] as? String
        else { return nil }
        self.testId = testId
        self.level = level
        self.tasks = tasks
        self.rate = rate
    }
}
