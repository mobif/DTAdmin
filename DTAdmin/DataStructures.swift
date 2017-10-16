//
//  DataStructures.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
class DataStructures: EntityStructure {
    
    struct User: Decodable {
        var id: String
        var username: String
        var roles: [String]
    }

    //Student: {user_id, gradebook_id, student_surname, student_name, student_fname, group_id, plain_password, photo}
    struct Student: Decodable {
        var user_id: String
        var gradebook_id: String
        var student_surname: String
        var student_name: String
        var student_fname: String
        var group_id: String
        var plain_password: String
        var photo: String
    }
}
