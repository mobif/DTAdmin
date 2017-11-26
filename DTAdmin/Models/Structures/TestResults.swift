//
//  TestResults.swift
//  DTAdmin
//
//  Created by Yurii Krupa on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct TestResults: Serializable {
    var sessionId: String
    var studentId: String
    var studentName: String?
    var testId: String
    var sessionDate: String?
    var startTime: String?
    var endTime: String?
    var result: String
    var questions: [[String: String]]?
    var trueAnswers: [[String: String]]?
    var answers: String?
    
    init?(dictionary: [String:Any]) {
        guard let sessionId = dictionary["session_id"] as? String,
            let studentId = dictionary["student_id"] as? String,
            let testId = dictionary["test_id"] as? String,
            let result = dictionary["result"] as? String
            else { return nil }
        self.sessionId = sessionId
        self.studentId = studentId
        self.testId = testId
        self.result = result
    }
    
    var dictionary: [String : Any] {
        var result: [String: Any] = ["session_id": self.sessionId, "student_id": self.studentId, "test_id": self.testId, "result": self.result]
        if let sessionDate = self.sessionDate { result["session_date"] = sessionDate }
        return result
    }
}
