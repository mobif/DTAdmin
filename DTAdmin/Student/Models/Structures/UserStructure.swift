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
    init?(dictionary: [String: Any]) {
        id = dictionary["id"] as? String
        lastLogin = dictionary["last_login"] as? String
        guard let email = dictionary["email"] as? String,
            let userName = dictionary["username"] as? String,
            let password = dictionary["password"] as? String,
            let logins = dictionary["logins"] as? String,
            let roles = dictionary["roles"] as? [String]
            else { return nil }
        self.email = email
        self.userName = userName
        self.password = password
        self.logins = logins
        self.roles = roles
    }
    var dictionary: [String: Any] {
        var result:[String: Any] = ["email": self.email, "username": self.userName, "password": self.password, "logins": self.logins, "roles": self.roles]
        if let id = self.id { result["id"] = id }
        if let lastLogin = self.lastLogin { result["last_login"] = lastLogin}
        return result
    }
}

