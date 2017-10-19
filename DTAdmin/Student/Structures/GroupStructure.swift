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
    var group_id: String//Int
    var group_name: String
    var speciality_id: String//Int
    var faculty_id: String//Int
}
