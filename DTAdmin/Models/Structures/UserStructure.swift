//
//  UserStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
struct UserStructure: Serializable {
    var id: String?
    var userName: String
    var email: String
    var password: String
    var logins: String
    var lastLogin: String?
    var roles: [String]?
    
    init?(dictionary: [String: Any]) {
        id = dictionary["id"] as? String
        lastLogin = dictionary["last_login"] as? String
        roles = dictionary["roles"] as? [String]
        guard let email = dictionary["email"] as? String,
            let userName = dictionary["username"] as? String,
            let password = dictionary["password"] as? String,
            let logins = dictionary["logins"] as? String
            else { return nil }
        self.email = email
        self.userName = userName
        self.password = password
        self.logins = logins
    }
    
    var dictionary: [String: Any] {
        var result: [String: Any] = ["email": self.email, "username": self.userName,
                                     "password": self.password, "password_confirm": password,
                                     "logins": self.logins]
        //    if let id = self.id { result["id"] = id }
        if let lastLogin = self.lastLogin { result["last_login"] = lastLogin }
        if let roles = roles { result["roles"] = roles }
        return result
    }
}

