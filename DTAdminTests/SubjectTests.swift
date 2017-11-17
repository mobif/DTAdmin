//
//  SubjectTests.swift
//  DTAdminTests
//
//  Created by ITA student on 11/9/17.
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
        DataManager.shared.getList(byEntity: .subject) { subjestArray, errorMessage in
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
        var subjectResult: SubjectStructure?
        let newSubject = SubjectStructure(dictionary: ["subject_name" : "Example for delete2.0", "subject_description" : "Example for delete2.0"])
        var error: String?
        weak var promise = expectation(description: "Add new subject record")
        DataManager.shared.insertEntity(entity: newSubject!, typeEntity: .subject) { subjectRecord, errorMessage in
            error = errorMessage
            let result = subjectRecord as! [[String : Any]]
            let resultFirst = result.first!
            subjectResult = SubjectStructure(dictionary: resultFirst)
            print(subjectResult!)
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(subjectResult)
    }
    
    func testUpdateSubject() {
        let updateSubject = SubjectStructure(dictionary: ["subject_name" : "Example for delete2.1", "subject_description" : "Example for delete2.1"])
        var error: String?
        weak var promise = expectation(description: "Update subject record")
        DataManager.shared.updateEntity(byId: "208", entity: updateSubject!, typeEntity: .subject) { errorMessage in
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
    }
    
    func testDeleteSubject() {
        var error: String?
        weak var promise = expectation(description: "Delete subject record")
        DataManager.shared.deleteEntity(byId: "208", typeEntity: .subject) { response, errorMessage in
            error = errorMessage
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
    }
    
    func testInit() {
        let subjectExample = ["subject_name": "Franch", "subject_description": "Basics"]
        let newSubject = SubjectStructure(dictionary: subjectExample)
        XCTAssertEqual(newSubject?.name, "Franch")
        XCTAssertEqual(newSubject?.description, "Basics")
        XCTAssertNil(newSubject?.id)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

