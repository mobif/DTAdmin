//
//  TestQuestions.swift
//  DTAdminTests
//
//  Created by Володимир on 06.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class TestQuestions: XCTestCase {
    
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
    func testGetQuestionsByLevelRand() {
        weak var promise = expectation(description: "Get list students by group")
        var questionList: [QuestionStructure]?
        var errorRequest: String?
        DataManager.shared.getQuestionsRand(byLevel: "1", testID: "1", number: "3") {
            (questions, error) in
            errorRequest = error
            questionList = questions
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(errorRequest)
        XCTAssertNotNil(questionList)
    }
    func testGetQuestionIdsRand() {
        weak var promise = expectation(description: "Get list students by group")
        var questionList: [String]?
        var errorRequest: String?
        DataManager.shared.getQuestionIdsRand(byLevel: "1", testID: "1", number: "3") {
            (questions, error) in
            errorRequest = error
            questionList = questions
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(errorRequest)
        XCTAssertNotNil(questionList)
    }
    func testGetAnswers() {
        weak var promise = expectation(description: "Get list students by group")
        var questionList: [AnswerStructure]?
        var errorRequest: String?
        DataManager.shared.getAnswers(byQuestion: "1") {
            (questions, error) in
            errorRequest = error
            questionList = questions
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(errorRequest)
        XCTAssertNotNil(questionList)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
