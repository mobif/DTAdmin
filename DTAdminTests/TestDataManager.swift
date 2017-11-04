//
//  TestDataManager.swift
//  DTAdminTests
//
//  Created by Володимир on 04.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

var sessionUnderTest: URLSession!

class TestDataManager: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CommonNetworkManager.shared().logIn(username: "admin", password: "dtapi_admin") { (user, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(user)
            sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        }
    }
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    func testGetListUsers() {
        let promise = expectation(description: "User list")
        var responseError: String?
        var users: [UserStructure]?
        DataManager.shared.getList(byEntity: .User) { (list, error) in
            responseError = error
            users = list as? [UserStructure]
            promise.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(users)
    }
    func testGetListStudents() {
        let promise = expectation(description: "Student list")
        var responseError: String?
        var students: [StudentStructure]?
        DataManager.shared.getList(byEntity: .Student) { (list, error) in
            responseError = error
            students = list as? [StudentStructure]
            promise.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNotNil(responseError)
        XCTAssertNil(students)
    }
    func testGetListGroup() {
        let promise = expectation(description: "Group list")
        var responseError: String?
        var groups: [GroupStructure]?
        DataManager.shared.getList(byEntity: .Group) { (list, error) in
            responseError = error
            groups = list as? [GroupStructure]
            promise.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(groups)
    }
    func testGetListAnswer() {
        let promise = expectation(description: "Answer list")
        var responseError: String?
        var answers: [AnswerStructure]?
        DataManager.shared.getList(byEntity: .Answer) { (list, error) in
            responseError = error
            answers = list as? [AnswerStructure]
            promise.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNotNil(responseError)
        XCTAssertNil(answers)
    }
    func testGetListFaculty() {
        let promise = expectation(description: "Faculty list")
        var responseError: String?
        var faculties: [FacultyStructure]?
        DataManager.shared.getList(byEntity: .Answer) { (list, error) in
            responseError = error
            faculties = list as? [FacultyStructure]
            promise.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNotNil(responseError)
        XCTAssertNil(faculties)
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
