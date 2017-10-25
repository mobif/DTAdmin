//
//  StudentStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct StudentStructure {
    
    var userId: String?
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
    
    init(dictionary: [String: String]) {
        userId = dictionary["user_id"]
        userName = dictionary["username"] ?? ""
        password = dictionary["password"] ?? ""
        passwordConfirm = dictionary["password_confirm"] ?? ""
        plainPassword = dictionary["plain_password"] ?? ""
        email = dictionary["email"] ?? ""
        gradebookId = dictionary["gradebook_id"] ?? ""
        studentSurname = dictionary["student_surname"] ?? ""
        studentName = dictionary["student_name"] ?? ""
        studentFname = dictionary["student_fname"] ?? ""
        groupId = dictionary["group_id"] ?? ""
        photo = dictionary["photo"] ?? ""
    }


}
