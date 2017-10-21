//
//  User.swift
//  DTAdmin
//
//  Created by mac6 on 10/21/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct User {
    var id: String?
    var userName: String?
    var roles: [String]?
    
    init() {}
    
    init(json: [String: Any]) {
        if let id = json[Keys.ID_KEY] as? String {
            self.id = id
        }
        if let userName = json[Keys.USER_NAME_KEY] as? String {
            self.userName = userName
        }
        if let roles = json[Keys.ROLES_KEY] as? [String] {
            self.roles = roles
        }
    }
}
