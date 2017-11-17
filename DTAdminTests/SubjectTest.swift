//
//  TestSubject.swift
//  DTAdminTests
//
//  Created by ITA student on 11/14/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class SubjectTest: XCTestCase {

    func testInit() {
        let subjectExample = ["subject_name": "Franch", "subject_description": "Basics"]
        let newSubject = SubjectStructure(dictionary: subjectExample)
        XCTAssertEqual(newSubject?.name, "Franch")
        XCTAssertEqual(newSubject?.description, "Basics")
        XCTAssertNil(newSubject?.id)
    }
    
}
