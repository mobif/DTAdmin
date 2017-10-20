//
//  UserStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct UserGetStructure: Codable {

    var id: String
    var username: String
    var email: String
    var password: String
    var logins: String
    var lastLogin: String
    
    init(json:[String:String]){
        id = json["id"] ?? ""
        username = json["username"] ?? ""
        email = json["email"] ?? ""
        password = json["password"] ?? ""
        logins = json["logins"] ?? ""
        lastLogin = json["last_login"] ?? ""
    }

}
