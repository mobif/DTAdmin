//
//  AnswerStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct AnswerStructure {
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
}
