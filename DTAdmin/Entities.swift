//
//  Entities.swift
//  DTAdmin
//
//  Created by Admin on 18.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct Group: Decodable, Encodable {
    let group_id: String?
    let group_name: String
    let faculty_id: String
    let speciality_id: String
    
    init(group_name: String,faculty_id: String,speciality_id: String) {
        self.group_id = nil
        self.group_name = group_name
        self.faculty_id = faculty_id
        self.speciality_id = speciality_id
    }
    init(group_id: String,group_name: String,faculty_id: String,speciality_id: String) {
        self.group_id = group_id
        self.group_name = group_name
        self.faculty_id = faculty_id
        self.speciality_id = speciality_id
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

