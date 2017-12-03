//
//  QuestionTests.swift
//  DTAdminTests
//
//  Created by ITA student on 11/14/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class QuestionTest: XCTestCase {
    
    func testInit() {
        let questionExample = ["test_id": "4", "question_text": "How many 2+3?", "level": "1", "type": "1"]
        let newQuestion = QuestionStructure(dictionary: questionExample)
        XCTAssertEqual(newQuestion?.testId, "4")
        XCTAssertEqual(newQuestion?.questionText, "How many 2+3?")
        XCTAssertEqual(newQuestion?.level, "1")
        XCTAssertEqual(newQuestion?.type, "1")
        XCTAssertNil(newQuestion?.id)
    }
    
}
