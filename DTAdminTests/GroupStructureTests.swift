//
//  GroupStructureTests.swift
//  DTAdminTests
//
//  Created by Admin on 05.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class GroupStructureTests: XCTestCase {
    
    func testInit() {
        let groupDictionary = [
            "group_name": "new group",
            "speciality_id": "1",
            "faculty_id": "1"
        ]
        var newGroup = GroupStructure(dictionary: groupDictionary)
        XCTAssertEqual(newGroup?.groupName, "new group")
        XCTAssertEqual(newGroup?.specialityId, "1")
        XCTAssertEqual(newGroup?.facultyId, "1")
        XCTAssertNil(newGroup?.groupId)
        newGroup?.groupId = "1"
        XCTAssertEqual(newGroup?.groupId, "1")
        
    }
    
}
