//
//  AnswerStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

struct AnswerStructure: Serializable {
    var id: String?
    var questionId: String
    var trueAnswer: String
    var answerText: String
    var attachment: UIImage?
    init?(dictionary: [String: Any]) {
        id = dictionary["answer_id"] as? String
        if let photoCode64 = dictionary["attachment"] as? String {
            attachment = UIImage.decode(fromBase64: photoCode64)
        }
        guard let questionId = dictionary["question_id"] as? String,
            let trueAnswer = dictionary["true_answer"] as? String,
            let answerText = dictionary["answer_text"] as? String
            else { return nil }
        self.questionId = questionId
        self.trueAnswer = trueAnswer
        self.answerText = answerText
    }
    var dictionary: [String: Any] {
        var result: [String: Any] = [
                                     "question_id": self.questionId,
                                     "true_answer": self.trueAnswer,
                                     "answer_text": self.answerText
                                    ]
        if let id = id { result["answer_id"] = id }
        if let attachment = attachment {
            result["attachment"] = UIImage.encode(fromImage: attachment)
        } else {
            result["attachment"] = ""
        }
        return result
    }
}
