//
//  DTAdminTests.swift
//  DTAdminTests
//
//  Created by Admin on 05.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class DTAdminTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let mockData = MockDataManager.shared
        mockData.setData(caseURL: "vps9615.hyperhost.name/group/getRecords")
        weak var promise = expectation(description: "User list")
        var responseError: String?
        var groups: [GroupStructure]?
        mockData.getList(byEntity: .group) {
            (list, error) in
            responseError = error
            groups = list as? [GroupStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(groups)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
