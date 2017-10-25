//
//  GroupStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct GroupStructure: Codable{
    var groupId: String
    var groupName: String
    var specialityId: String
    var facultyId: String
    
    enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
        case groupName = "group_name"
        case specialityId = "speciality_id"
        case facultyId = "faculty_id"
    }
    init(dictionary: [String: String]) {
        groupId = dictionary["group_id"] ?? ""
        groupName = dictionary["group_name"] ?? ""
        specialityId = dictionary["speciality_id"] ?? ""
        facultyId = dictionary["faculty_id"] ?? ""
    }
}
