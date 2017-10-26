//
//  TestStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
struct TestStructure {
    var id: String?
    var name: String
    var subjectId: String
    var tasks: Int
    var timeForTest: String
    var enabled: String
    var attempts: String
    init?(dictionary: [String: Any]) {
        id = dictionary["test_id"] as? String
        guard let name = dictionary["test_name"] as? String,
            let subjectId = dictionary["subject_id"] as? String,
            let tasks = dictionary["tasks"] as? Int,
            let timeForTest = dictionary["time_for_test"] as? String,
            let enabled = dictionary["enabled"] as? String,
            let attempts = dictionary["attempts"] as? String
            else { return nil }
        self.name = name
        self.subjectId = subjectId
        self.tasks = tasks
        self.timeForTest = timeForTest
        self.enabled = enabled
        self.attempts = attempts
    }
}
