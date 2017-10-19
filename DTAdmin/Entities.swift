//
//  Entities.swift
//  DTAdmin
//
//  Created by Kravchuk on 18.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class Group {
    let groupId: String
    let groupName: String
    let facultyId: String
    let specialityId: String
    var facultyName: String?
    var facultyDescription: String?
    var specialityCode: String?
    var specialityName: String?
    
    init(groupId: String,groupName: String,facultyId: String,specialityId: String) {
        self.groupId = groupId
        self.groupName = groupName
        self.facultyId = facultyId
        self.specialityId = specialityId
        self.facultyName = nil
        self.facultyDescription = nil
        self.specialityCode = nil
        self.specialityName = nil
    }
    
    static func getGroupsFromJSON(json:[[String:String]]) -> [Group] {
        var groups = [Group]()
        for group in json {
            if let groupId = group["group_id"],
                let groupName = group["group_name"],
                let facultyId = group["faculty_id"],
                let specialityId = group["speciality_id"] {
                groups.append(Group(groupId: groupId, groupName: groupName, facultyId: facultyId, specialityId: specialityId))
            }
        }
        return groups
    }
    
}

class Faculty {
    let facultyId: String
    let facultyName: String
    let facultyDescription: String
    
    init(facultyName: String, facultyId: String, facultyDescription: String) {
        self.facultyId = facultyId
        self.facultyName = facultyName
        self.facultyDescription = facultyDescription
    }
    
    static func getFacultiesFromJSON(json:[[String:String]]) -> [Faculty] {
        var faculties = [Faculty]()
        for faculty in json {
            if let facultyId = faculty["faculty_id"],
                let facultyName = faculty["faculty_name"],
                let facultyDescription = faculty["faculty_description"] {
                faculties.append(Faculty(facultyName: facultyName, facultyId: facultyId, facultyDescription: facultyDescription))
            }
        }
        return faculties
    }
}

class Speciality {
    let specialityId: String
    let specialityCode: String
    let specialityName: String
    
    init(specialityCode: String, specialityName: String, specialityId: String) {
        self.specialityId = specialityId
        self.specialityCode = specialityCode
        self.specialityName = specialityName
    }
    
    static func getSpecialitiesFromJSON(json:[[String:String]]) -> [Speciality] {
        var specialities = [Speciality]()
        for faculty in json {
            if let specialityId = faculty["speciality_id"],
                let specialityCode = faculty["speciality_code"],
                let specialityName = faculty["speciality_name"] {
                specialities.append(Speciality(specialityCode: specialityCode, specialityName: specialityName, specialityId: specialityId))
            }
        }
        return specialities
    }
}











