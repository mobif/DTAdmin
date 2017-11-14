//
//  UserStructureTests.swift
//  DTAdminTests
//
//  Created by ITA student on 11/12/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class UserStructureTests: XCTestCase {
    
  func testStuctureInit() {
    let dictionary = ["id": "0",
                      "email": "admin@example.com",
                      "username": "admin",
                      "password": "1qaz2wsx",
                      "logins": "100500"]
    var user = UserStructure(dictionary: dictionary)
    XCTAssertEqual(user?.id, "0")
    XCTAssertEqual(user?.email, "admin@example.com")
    XCTAssertEqual(user?.userName, "admin")
    XCTAssertEqual(user?.password, "1qaz2wsx")
    XCTAssertEqual(user?.logins, "100500")
    
  }
    
}
