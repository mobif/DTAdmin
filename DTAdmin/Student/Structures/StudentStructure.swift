//
//  StudentStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
/*
 * JSON Record for new student
 * email, username, password, password_confirm
 * gradebook_id, student_surname, student_name, student_fname, group_id
 */
struct StudentStructure: Codable {
//    var username: String
//    var password: String
//    var password_confirm: String
//    var plain_password: String
//    var email: String
//    var gradebook_id: String
//    var student_surname: String
//    var student_name: String
//    var student_fname: String
//    var group_id: String
//    var photo: String
//
    var userId: String
    var username: String
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
    
    init(json:[String:String]) {
        userId = json["user_id"] ?? ""
        username = json["username"] ?? ""
        password = json["password"] ?? ""
        passwordConfirm = json["password_confirm"] ?? ""
        plainPassword = json["plain_password"] ?? ""
        email = json["email"] ?? ""
        gradebookId = json["gradebook_id"] ?? ""
        studentSurname = json["student_surname"] ?? ""
        studentName = json["student_name"] ?? ""
        studentFname = json["student_fname"] ?? ""
        groupId = json["group_id"] ?? ""
        photo = json["photo"] ?? ""
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
extension String {
    func camelToSnake() -> String {
        return self.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1_$2", options: .regularExpression, range: self.startIndex ..< self.endIndex).lowercased()
    }
    func snakeToCamel() -> String {
        var ressult = ""
        let items = self.components(separatedBy: "_")
        items.enumerated().forEach {
            ressult += 0 == $0 ? $1 : $1.capitalized
        }
        return ressult
    }
}
