//
//  UserStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
struct UserStructure: Codable{
    var id: String
    var username: String
    var roles: [String]
}

struct UserGetStructure: Codable {
    
    var id: String
    var userName: String
    var email: String
    var password: String
    var logins: String
    var lastLogin: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "username"
        case email = "email"
        case password = "password"
        case logins = "logins"
        case lastLogin = "last_login"
    }
}
