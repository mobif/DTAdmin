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
//[{"id":"23","email":"panda222@gmail.com","username":"panda222","password":"bfc3005a4d1ff300083d7ade7fced2a349665031c3acd446cb08acfba4188e30","logins":"0","last_login":null}]
struct UserGetStructure: Codable {
    
    var id: String
    var email: String
    var userName: String
    var password: String
    var logins: String
    var lastLogin: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case userName = "username"
        case password = "password"
        case logins = "logins"
        case lastLogin = "last_login"
    }
}

