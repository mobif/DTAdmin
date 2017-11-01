//
//  AnswerStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct AnswerStructure: Serializable {
    var id: String?
    var questionId: String
    var trueAnswer: String
    var answerText: String
    var attachmant: String
    init?(dictionary: [String: Any]) {
        id = dictionary["answer_id"] as? String
        guard let questionId = dictionary["question_id"] as? String,
            let trueAnswer = dictionary["true_answer"] as? String,
            let answerText = dictionary["answer_text"] as? String,
            let attachment = dictionary["attachment"] as? String
            else { return nil }
        self.questionId = questionId
        self.trueAnswer = trueAnswer
        self.answerText = answerText
        self.attachmant = attachment
    }
    var dictionary: [String: Any] {
        var result: [String: Any] = ["question_id": self.questionId, "true_answer": self.trueAnswer, "answer_text": self.answerText, "attachment": self.attachmant]
        if let id = id { result["answer_id"] = id }
        return result
    }
}
