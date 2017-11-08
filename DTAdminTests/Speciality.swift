//
//  Speciality.swift
//  DTAdminTests
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin
class Speciality: XCTestCase {
    
    func testStructure(){
        
        let testDictionary: [String: String] = ["speciality_code": "777", "speciality_name": "testSpeciality"]
        let newSpecialityForTest = SpecialityStructure(dictionary: testDictionary)
        
        XCTAssertEqual(newSpecialityForTest!.code, "777")
        XCTAssertEqual(newSpecialityForTest!.name, "testSpeciality")

    }
    

    
}
