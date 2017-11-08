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
        weak var promise = expectation(description: "Get Questions by Level")
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
        weak var promise = expectation(description: "Get Questions IDs randomly by level")
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
        weak var promise = expectation(description: "Get answers by question")
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
    func testCountRecordsByTest() {
        weak var promise = expectation(description: "Test counting of records by test")
        var records: UInt?
        var errorRequest: String?
        DataManager.shared.countRecords(byTest: "1") {
            (count, error) in
            errorRequest = error
            records = count
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(errorRequest)
        XCTAssertNotNil(records)
    }
    func testGetRecordsRangeByTest() {
        weak var promise = expectation(description: "Test get Records range test")
        var questionList: [QuestionStructure]?
        var errorRequest: String?
        DataManager.shared.getRecordsRange(byTest: "1", limit: "3", offset: "2") {
         (list, error) in
            questionList = list
            errorRequest = error
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
