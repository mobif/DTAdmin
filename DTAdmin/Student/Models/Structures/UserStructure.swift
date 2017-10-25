//
//  UserStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
struct UserStructure {
    var id: String?
    var userName: String
    var email: String
    var password: String
    var logins: String
    var lastLogin: String?
    var roles: [String]

    init(dictionary: [String: String]) {
        id = dictionary["id"] ?? ""
        email = dictionary["email"] ?? ""
        userName = dictionary["username"] ?? ""
        password = dictionary["password"] ?? ""
        logins = dictionary["logins"] ?? ""
        lastLogin = dictionary["last_login"] ?? ""
        roles = dictionary["roles"] ?? []
    }
}

