//
//  TestSubject.swift
//  TestSubject
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class TestSubject: XCTestCase {
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
    
    func testShowSubject() {
        var subject = [SubjectStructure]()
        var error: String?
        weak var promise = expectation(description: "Get all subject records")
        DataManager.shared.getList(byEntity: .Subject) { subjestArray, errorMessage in
            subject = subjestArray as! [SubjectStructure]
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(subject)
    }
    
    func testAddNewSubject() {
        let newSubject = SubjectStructure(dictionary: ["subject_name" : "New subject", "subject_description" : "New description"])
        var error: String?
        weak var promise = expectation(description: "Add new subject record")
        DataManager.shared.insertEntity(entity: newSubject!, typeEntity: .Subject) { subjectRecord, errorMessage in
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
