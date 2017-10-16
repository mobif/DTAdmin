//
//  GroupStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
//Group: {group_id, group_name, faculty_id, speciality_id}
struct GroupStructure: Decodable{
    var group_id: String
    var group_name: String
    var faculty_id: String
    var speciality_id: String
}
