//
//  AdminModel.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import Foundation

class UserModel {
  
  struct Admin: Decodable {
    let id: String
    let username: String
    let roles: [String]
    
    init(json: [String: Any]) {
      id = json["id"] as? String ?? "-1"
      username = json["username"] as? String ?? "userDefault"
      roles = json["roles"] as? [String] ?? ["none"]
    }
  }
  struct Admins: Decodable {
    let id: String
    let username: String
    let email: String
    let password: String
    let logins: String
    let last_login: String?
    
    init(json: [String: Any]) {
      self.id = json["id"] as? String ?? "-1"
      self.username = json["username"] as? String ?? "null"
      self.email = json["email"] as? String ?? "null"
      self.password = json["password"] as? String ?? "null"
      self.logins = json["logins"] as? String ?? "null"
      self.last_login = json["last_login"] as? String ?? nil
    }
  }
  struct NewAdmin {
    let userName: String
    let password: String
    let email: String
    
    var dictionaryRepresentation: [String:String] {
      return [
        "username": userName,
        "password": password,
        "password_confirm": password,
        "email": email]
    }
    
  }
}
