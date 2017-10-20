//
//  GroupStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
//Group: {group_id, group_name, faculty_id, speciality_id}
//[{"group_id":"1","group_name":"СІ-12-1","speciality_id":"1","faculty_id":"1"}]
struct GroupStructure: Codable{
    var groupId: String
    var groupName: String
    var specialityId: String
    var facultyId: String
    
    init(json:[String:String]){
        groupId = json["group_id"] ?? ""
        groupName = json["grop_name"] ?? ""
        specialityId = json["speciality_id"] ?? ""
        facultyId = json["faculty_id"] ?? ""
    }
    
    func toJSON() -> [String:String] {
        var json = [String:String]()
        let groupMirror = Mirror(reflecting: self)
        for (name, value) in groupMirror.children {
            guard let nameUnwraped = name else { continue }
            json[nameUnwraped.camelToSnake()] = "\(value)"
        }
        return json
    }
}

