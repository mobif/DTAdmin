//
//  AnswerTest.swift
//  DTAdminTests
//
//  Created by ITA student on 11/9/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class AnswerTest: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        CommonNetworkManager.shared().logIn(username: "admin", password: "dtapi_admin") { (user, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(user)
            self.sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        }
    }
    
    override func tearDown() {
        self.sessionUnderTest = nil
        super.tearDown()
    }
    
    func testShowAnswers() {
        var answers = [AnswerStructure]()
        var error: String?
        weak var promise = expectation(description: "Get all answers by question")
        DataManager.shared.getAnswers(byQuestion: "5"){ answersArray, errorMessage in
            answers = answersArray as! [AnswerStructure]
            print(answers)
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(answers)
    }
    
    func testAddNewAnswer() {
        var answerResult: AnswerStructure?
        let newAnswer = AnswerStructure(dictionary: ["question_id": "5", "true_answer": "1", "answer_text": "5", "attachment": ""])
        var error: String?
        weak var promise = expectation(description: "Add new answer record")
        DataManager.shared.insertEntity(entity: newAnswer!, typeEntity: .answer) { answerRecord, errorMessage in
            error = errorMessage
            let result = answerRecord as! [[String : Any]]
            let resultFirst = result.first!
            answerResult = AnswerStructure(dictionary: resultFirst)
            print(answerResult!)
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(answerResult)
    }
    
    func testUpdateAnswer() {
        let updateAnswer = AnswerStructure(dictionary: ["question_id": "5", "true_answer": "1", "answer_text": "55", "attachment": ""])
        var error: String?
        weak var promise = expectation(description: "Update answer record")
        DataManager.shared.updateEntity(byId: "6", entity: updateAnswer!, typeEntity: .answer) { errorMessage in
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
    }
    
    func testDeleteAnswer() {
        var error: String?
        weak var promise = expectation(description: "Delete question record")
        DataManager.shared.deleteEntity(byId: "6", typeEntity: .answer) { response, errorMessage in
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
    }
    
    func testInit() {
        let answerExample = ["question_id": "1", "true_answer": "1", "answer_text": "5", "attachment": ""]
        let newAnswer = AnswerStructure(dictionary: answerExample)
        XCTAssertEqual(newAnswer!.questionId, "1")
        XCTAssertEqual(newAnswer!.trueAnswer, "1")
        XCTAssertEqual(newAnswer!.answerText, "5")
        XCTAssertEqual(newAnswer!.attachmant, "")
        XCTAssertNil(newAnswer!.id)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
