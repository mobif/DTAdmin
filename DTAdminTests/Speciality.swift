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
//        var testSpeciality: [SpecialityStructure]?
        var errorResponse: String?
        let testDictionary: [String: String] = ["speciality_code": "777", "speciality_name": "testSpeciality"]
        let newSpecialityForTest = SpecialityStructure(dictionary: testDictionary)
        
        XCTAssertEqual(newSpecialityForTest!.code, "777")
        XCTAssertEqual(newSpecialityForTest!.name, "testSpeciality")

        let testItem = newSpecialityForTest
        weak var promise = expectation(description: "Test insert of fake speciality")
        DataManager.shared.insertEntity(entity: testItem!, typeEntity: Entities.Speciality) { (newSpeciality, error) in
            let speciality = newSpeciality as? SpecialityStructure
            let specialityId = speciality?.id
            let code = speciality?.code
            let name = speciality?.name
            errorResponse = error

            XCTAssertNil(errorResponse)
            XCTAssertNotNil(specialityId)
            XCTAssertEqual(code, newSpecialityForTest!.code)
            XCTAssertEqual(name, newSpecialityForTest!.name)
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        

        
    }
    

    
}
