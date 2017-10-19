//
//  Entities.swift
//  DTAdmin
//
//  Created by Admin on 18.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class Group: Decodable, Encodable {
    let group_id: String?
    let group_name: String
    let faculty_id: String
    let speciality_id: String
    var faculty_name: String?
    var faculty_description: String?
    var speciality_code: String?
    var speciality_name: String?
    
    init(group_name: String,faculty_id: String,speciality_id: String) {
        self.group_id = nil
        self.faculty_name = nil
        self.faculty_description = nil
        self.speciality_code = nil
        self.speciality_name = nil
        self.group_name = group_name
        self.faculty_id = faculty_id
        self.speciality_id = speciality_id
    }
    init(group_id: String,group_name: String,faculty_id: String,speciality_id: String) {
        self.group_id = group_id
        self.group_name = group_name
        self.faculty_id = faculty_id
        self.speciality_id = speciality_id
        self.faculty_name = nil
        self.faculty_description = nil
        self.speciality_code = nil
        self.speciality_name = nil
    }
    init(group_id: String,group_name: String,faculty_id: String,speciality_id: String,
         faculty_name: String, faculty_description: String, speciality_code: String, speciality_name: String) {
        self.group_id = group_id
        self.group_name = group_name
        self.faculty_id = faculty_id
        self.speciality_id = speciality_id
        self.faculty_name = faculty_name
        self.faculty_description = faculty_description
        self.speciality_code = speciality_code
        self.speciality_name = speciality_name
    }
    
}

struct Faculty: Decodable, Encodable {
    let faculty_id: String?
    let faculty_name: String
    let faculty_description: String
}

struct Speciality: Decodable, Encodable {
    let speciality_id: String?
    let speciality_code: String
    let speciality_name: String
}











