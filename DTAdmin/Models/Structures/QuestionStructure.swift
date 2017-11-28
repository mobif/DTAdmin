//
//  QuestionStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

struct QuestionStructure: Serializable {
    var id: String?
    var testId: String
    var questionText: String
    var level: String
    var type: String
    var attachment: UIImage?
    init?(dictionary: [String: Any]) {
        id = dictionary["question_id"] as? String
        if let photoCode64 = dictionary["attachment"] as? String {
            attachment = UIImage.decode(fromBase64: photoCode64)
        }
        guard let testId = dictionary["test_id"] as? String,
            let questionText = dictionary["question_text"] as? String,
            let level = dictionary["level"] as? String,
            let type = dictionary["type"] as? String
            else { return nil }
        self.testId = testId
        self.questionText = questionText
        self.level = level
        self.type = type
    }
    var dictionary: [String: Any] {
        var result: [String: Any] = ["test_id": self.testId,
                                     "question_text": self.questionText,
                                     "level": self.level,
                                     "type": self.type
                                     ]
        if let id = id { result["question_id"] = id }
        if let attachment = attachment {
            result["attachment"] = UIImage.encode(fromImage: attachment)
        } else {
            result["attachment"] = ""
        }
        return result
    }
}


