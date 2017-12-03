//
//  AnswerTest.swift
//  DTAdminTests
//
//  Created by ITA student on 11/14/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class AnswerTest: XCTestCase {
    
    func testInit() {
        let answerExample = ["question_id": "1", "true_answer": "1", "answer_text": "5", "attachment": ""]
        let newAnswer = AnswerStructure(dictionary: answerExample)
        XCTAssertEqual(newAnswer!.questionId, "1")
        XCTAssertEqual(newAnswer!.trueAnswer, "1")
        XCTAssertEqual(newAnswer!.answerText, "5")
        XCTAssertNil(newAnswer!.id)
    }
    
}
