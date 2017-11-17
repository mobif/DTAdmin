//
//  StudentStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

struct StudentStructure: Serializable {
    
    var userId: String?
    var userName: String?
    var password: String?
    var passwordConfirm: String?
    var plainPassword: String
    var email: String?
    var gradebookId: String
    var studentSurname: String
    var studentName: String
    var studentFname: String
    var groupId: String
    var photo: UIImage?
    init?(dictionary: [String: Any]) {
        userId = dictionary["user_id"] as? String
        userName = dictionary["username"] as? String
        password = dictionary["password"] as? String
        passwordConfirm = dictionary["password_confirm"] as? String
        email = dictionary["email"] as? String
        if let photoCode64 = dictionary["photo"] as? String {
            photo = UIImage.decode(fromBase64: photoCode64)
        }
        guard
            let plainPassword = dictionary["plain_password"] as? String,
            let gradebookId = dictionary["gradebook_id"] as? String,
            let studentSurname = dictionary["student_surname"] as? String,
            let studentName = dictionary["student_name"] as? String,
            let studentFname = dictionary["student_fname"] as? String,
            let groupId = dictionary["group_id"] as? String else { return nil }
        self.plainPassword = plainPassword
        self.gradebookId = gradebookId
        self.studentSurname = studentSurname
        self.studentName = studentName
        self.studentFname = studentFname
        self.groupId = groupId
    }
    var dictionary: [String: Any] {
        var result: [String: Any] = [ "plain_password": self.plainPassword, "gradebook_id": self.gradebookId, "student_surname": self.studentSurname, "student_name": self.studentName, "student_fname": self.studentFname, "group_id": self.groupId]
        if let userId = userId { result["user_id"] = userId }
        if let userName = userName { result["username"] = userName }
        if let email = email { result["email"] = email }
        if let password = password { result["password"] = password }
        if let passwordConfirm = passwordConfirm { result["password_confirm"] = passwordConfirm }
        if let photo = photo { result["photo"] = UIImage.encode(fromImage: photo) }
        return result
    }
}
