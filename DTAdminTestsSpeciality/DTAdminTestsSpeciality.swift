//
//  DTAdminTestsSpeciality.swift
//  DTAdminTestsSpeciality
//
//  Created by Volodymyr on 11/6/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class DTAdminTestsSpeciality: XCTestCase {

//    func testAplication(){
//        var testItem: SpecialityStructure?
//        let testDictionary: [String: Any] = ["speciality_code": "5.555", "speciality_name": "testSpeciality"]
//        testItem = SpecialityStructure(dictionary: testDictionary)
//        DataManager.shared.insertEntity(entity: testItem!, typeEntity: Entities.Speciality) { (result, error) in
//            guard let result = result as? [[String : Any]] else { return }
//            guard let firstResult = result.first else { return }
//            guard let specialityResult = SpecialityStructure(dictionary: firstResult) else { return }
//            }
    
//        var specialitiesArray = [SpecialityStructure]()
        
        
//        XCTAssertEqual(testItem, (["speciality_code": "5.555", "speciality_name": "testSpeciality"]) )
        
//    }
    
    
    
    func testHello(){
        var hello: String?
        XCTAssertNil(hello)
        
        hello = "hello"
        XCTAssertEqual(hello, "hello")
        
    }
    
    
    
}
