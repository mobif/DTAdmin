//
//  StudentStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct StudentStructure: Serializable {
    
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
    init?(dictionary: [String: Any]) {
        userId = dictionary["user_id"] as? String
        guard let userName = dictionary["username"] as? String,
            let password = dictionary["password"] as? String,
            let passwordConfirm = dictionary["password_confirm"] as? String,
            let plainPassword = dictionary["plain_password"] as? String,
            let email = dictionary["email"] as? String,
            let gradebookId = dictionary["gradebook_id"] as? String,
            let studentSurname = dictionary["student_surname"] as? String,
            let studentName = dictionary["student_name"] as? String,
            let studentFname = dictionary["student_fname"] as? String,
            let groupId = dictionary["group_id"] as? String,
            let photo = dictionary["photo"] as? String else { return nil }
        self.userName = userName
        self.password = password
        self.passwordConfirm = passwordConfirm
        self.plainPassword = plainPassword
        self.email = email
        self.gradebookId = gradebookId
        self.studentSurname = studentSurname
        self.studentName = studentName
        self.studentFname = studentFname
        self.groupId = groupId
        self.photo = photo
    }
    var dictionary: [String: Any] {
        var result: [String: Any] = ["username": self.userName, "password": self.password, "password_confirm": self.passwordConfirm, "plain_password": self.plainPassword, "email": self.email, "gradebook_id": self.gradebookId, "student_surname": self.studentSurname, "student_name": self.studentName, "student_fname": self.studentFname, "group_id": self.groupId, "photo": self.photo]
        if let userId = userId { result["user_id"] = userId }
        return result
    }
}
