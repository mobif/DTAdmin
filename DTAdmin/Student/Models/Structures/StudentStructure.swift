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
    
    init(dictionary: [String: Any]) {
        userId = dictionary["user_id"] as? String
        userName = dictionary["username"] as? String ?? ""
        password = dictionary["password"] as? String ?? ""
        passwordConfirm = dictionary["password_confirm"] as? String ?? ""
        plainPassword = dictionary["plain_password"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        gradebookId = dictionary["gradebook_id"] as? String ?? ""
        studentSurname = dictionary["student_surname"] as? String ?? ""
        studentName = dictionary["student_name"] as? String ?? ""
        studentFname = dictionary["student_fname"] as? String ?? ""
        groupId = dictionary["group_id"] as? String ?? ""
        photo = dictionary["photo"] as? String ?? ""
    }
}
