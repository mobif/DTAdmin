//
//  StudentStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct StudentGetStructure: Codable {
    
    var userId: String
    var gradebookId: String
    var studentSurname: String
    var studentName: String
    var studentFname: String
    var groupId: String
    var plainPassword: String
    var photo: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case gradebookId = "gradebook_id"
        case studentSurname = "student_surname"
        case studentName = "student_name"
        case studentFname = "student_fname"
        case groupId = "group_id"
        case plainPassword = "plain_password"
        case photo = "photo"
    }
}

struct StudentPostStructure: Codable {
    var userName: String
    var password: String
    var passwordConfirm: String
    var plainPassword: String
    var email: String
    var gradebookId: String
    var studentSurname: String
    var studentName: String
    var studentFname: String
    var groupId: String
    var photo: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case password = "password"
        case passwordConfirm = "password_confirm"
        case plainPassword = "plain_password"
        case email = "email"
        case gradebookId = "gradebook_id"
        case studentSurname = "student_surname"
        case studentName = "student_name"
        case studentFname = "student_fname"
        case groupId = "group_id"
        case photo = "photo"
    }
}
