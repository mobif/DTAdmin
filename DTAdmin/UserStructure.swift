//
//  UserStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
//{id, email, username, password, logins, last_login}
struct UserStructure: Codable{
    var id: String
    var username: String
    var roles: [String]
    //var email: String
}

