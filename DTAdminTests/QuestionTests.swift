//
//  QuestionTests.swift
//  DTAdminTests
//
//  Created by ITA student on 11/9/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class QuestionTests: XCTestCase {
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
    
    func testShowQuestion() {
        var questions = [QuestionStructure]()
        var error: String?
        var count: UInt?
        weak var promise = expectation(description: "Get all question records")
        DataManager.shared.getCountItems(forEntity: .question) { number, errorMessage in
            error = errorMessage
            count = number
            DataManager.shared.getListRange(forEntity: .question, fromNo: 0, quantity: count!) { questionArray, errorMessage in
                questions = questionArray as! [QuestionStructure]
                print(questions)
                error = errorMessage
                promise?.fulfill()
                promise = nil
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(questions)
    }
    
    func testAddNewQuestion() {
        var questionResult: QuestionStructure?
        let newQuestion = QuestionStructure(dictionary: ["test_id": "4", "question_text": "How many 2+3?", "level": "1", "type": "1", "attachment": ""])
        var error: String?
        weak var promise = expectation(description: "Add new question record")
        DataManager.shared.insertEntity(entity: newQuestion!, typeEntity: .question) { questionRecord, errorMessage in
            error = errorMessage
            let result = questionRecord as! [[String : Any]]
            let resultFirst = result.first!
            questionResult = QuestionStructure(dictionary: resultFirst)
            print(questionResult!)
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(questionResult)
    }
    
    func testUpdateQuestion() {
        let updateQuestion = QuestionStructure(dictionary: ["test_id": "4", "question_text": "How many 2+4?", "level": "1", "type": "1", "attachment": ""])
        var error: String?
        weak var promise = expectation(description: "Update question record")
        DataManager.shared.updateEntity(byId: "208", entity: updateQuestion!, typeEntity: .question) { errorMessage in
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
    }
    
    func testDeleteQuestion() {
        var error: String?
        weak var promise = expectation(description: "Delete question record")
        DataManager.shared.deleteEntity(byId: "21", typeEntity: .question) { response, errorMessage in
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
    }
    
    func testInit() {
        let questionExample = ["test_id": "4", "question_text": "How many 2+3?", "level": "1", "type": "1", "attachment": ""]
        let newQuestion = QuestionStructure(dictionary: questionExample)
        XCTAssertEqual(newQuestion?.testId, "4")
        XCTAssertEqual(newQuestion?.questionText, "How many 2+3?")
        XCTAssertEqual(newQuestion?.level, "1")
        XCTAssertEqual(newQuestion?.type, "1")
        XCTAssertEqual(newQuestion?.attachment, "")
        XCTAssertNil(newQuestion?.id)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
