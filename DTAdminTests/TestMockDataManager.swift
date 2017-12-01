//
//  testMockDataManager.swift
//  DTAdminTests
//
//  Created by Володимир on 26.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin
class TestMockDataManager: XCTestCase {
    let mockData = MockDataManager.shared
    
    override func setUp() {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        if let pathBundle = testBundle.path(forResource: "test_cases", ofType: "json") {
            mockData.setPath(pathBundle)
        }
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetRecords() {
        weak var promise = expectation(description: "Group list")
        var responseError: String?
        var groups: [GroupStructure]?
        mockData.getList(byEntity: .group) {
            (list, error) in
            responseError = error?.info
            groups = list as? [GroupStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(groups)
        let groupCount = groups?.count
        XCTAssertEqual(groupCount, 3)
    }
    
    func testGetStudentsByGroup() {
        weak var promise = expectation(description: "Student list by group")
        var responseError: String?
        var students: [StudentStructure]?
        mockData.getStudents(forGroup: "1", withoutImages: true) {
            (list, error) in
            responseError = error?.info
            students = list
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(students)
        let studentsCount = students?.count
        XCTAssertEqual(studentsCount, 2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
}
