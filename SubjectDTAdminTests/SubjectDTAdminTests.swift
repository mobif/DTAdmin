//
//  SubjectDTAdminTests.swift
//  SubjectDTAdminTests
//
//  Created by ITA student on 11/1/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest

@testable import DTAdmin

class SubjectDTAdminTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    let loginParam = ["username" : "admin", "password" : "dtapi_admin"]
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testValidCallHTTPStatusCode200() {
        // given
        let url = URL(string: "https://vps9615.hyperhost.name/login/index")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginParam, options: []) else { return }
        request.httpBody = httpBody
        // 1
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: request) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            // 2
            promise.fulfill()
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
