//
//  Entities.swift
//  DTAdmin
//
//  Created by Kravchuk on 18.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class Group {
    var id: String
    var name: String
    var facultyId: String
    var specialityId: String
    var facultyName: String?
    var facultyDescription: String?
    var specialityCode: String?
    var specialityName: String?
    
    init?(dictionary: [String:String]) {
        guard let groupId = dictionary["group_id"],
            let groupName = dictionary["group_name"],
            let facultyId = dictionary["faculty_id"],
            let specialityId = dictionary["speciality_id"] else { return nil }
        self.id = groupId
        self.name = groupName
        self.facultyId = facultyId
        self.specialityId = specialityId
    }
}

class Faculty {
    var id: String
    var name: String
    var description: String
    
    init?(dictionary: [String:String]) {
        guard let facultyId = dictionary["faculty_id"],
            let facultyName = dictionary["faculty_name"],
            let facultyDescription = dictionary["faculty_description"] else { return nil }
        self.id = facultyId
        self.name = facultyName
        self.description = facultyDescription
    }
}

class Speciality {
    var id: String
    var code: String
    var name: String
    
    init?(dictionary: [String:String]) {
        guard let specialityId = dictionary["speciality_id"],
            let specialityCode = dictionary["speciality_code"],
            let specialityName = dictionary["speciality_name"] else { return nil }
        self.id = specialityId
        self.code = specialityCode
        self.name = specialityName
    }
}











