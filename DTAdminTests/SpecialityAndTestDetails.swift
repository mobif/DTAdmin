//
//  SpecialityAndTestDetails.swift
//  SpecialityAndTestDetails
//
//  Created by ITA student on 11/9/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class SpecialityAndTestDetails: XCTestCase {
    
    func testStructureForSpeciality(){
        let testDictionary: [String: String] = ["speciality_id": "24", "speciality_code": "777", "speciality_name": "testSpeciality"]
        let newSpecialityForTest = SpecialityStructure(dictionary: testDictionary)
        
        XCTAssertEqual(newSpecialityForTest!.id, "24")
        XCTAssertEqual(newSpecialityForTest!.code, "777")
        XCTAssertEqual(newSpecialityForTest!.name, "testSpeciality")
    }
    
    func testStructureForTestDetails(){
        let testDictionary: [String: String] = ["id": "1", "test_id": "12", "level": "7", "tasks": "2", "rate": "3"]
        let newTestDetailForTest = TestDetailStructure(dictionary: testDictionary)
        
        XCTAssertEqual(newTestDetailForTest!.id, "1")
        XCTAssertEqual(newTestDetailForTest!.testId, "12")
        XCTAssertEqual(newTestDetailForTest!.level, "7")
        XCTAssertEqual(newTestDetailForTest!.tasks, "2")
        XCTAssertEqual(newTestDetailForTest!.rate, "3")
    }
    
}
