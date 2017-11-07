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
        var testSpeciality: SpecialityStructure?
//        var specialityId: String = "0"
        let testDictionary: [String: String] = ["speciality_code": "777", "speciality_name": "testSpeciality"]
        let newSpeciality = SpecialityStructure(dictionary: testDictionary)
        
        XCTAssertEqual(newSpeciality!.code, "777")
        XCTAssertEqual(newSpeciality!.name, "testSpeciality")

//        let testItem = newSpeciality
//        DataManager.shared.insertEntity(entity: testItem!, typeEntity: Entities.Speciality) { (newId, error) in
//            let id = newId as! [SpecialityStructure]
//            let newError = error
//            print("*******************", id, error)
//        }
        
    }
    

    
}
