//
//  StudentStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
//Apologize for using snake_style instead CamelCase that unrelated to The Code Convention but required by external API. :)
struct StudentGetStructure: Codable {
    var user_id: String
    var gradebook_id: String
    var student_surname: String
    var student_name: String
    var student_fname: String
    var group_id: String
    var plain_password: String
    var photo: String
}
/*
 * JSON Record for new student
 * email, username, password, password_confirm
 * gradebook_id, student_surname, student_name, student_fname, group_id
 */
struct StudentPostStructure: Codable {
    var username: String
    var password: String
    var password_confirm: String
    var plain_password: String
    var email: String
    var gradebook_id: String
    var student_surname: String
    var student_name: String
    var student_fname: String
    var group_id: String
    var photo: String
}
