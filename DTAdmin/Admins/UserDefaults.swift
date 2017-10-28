//
//  UserDefaults.swift
//  DTAdmin
//
//  Created by ITA student on 10/28/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//
import UIKit

extension UserDefaults {
  
  private enum UserDefaultsKeys: String {
    case isLoggedIn
    case userName
    case cookieValue
  }
  
  func setLoggedIn(to value: Bool) {
    set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    synchronize()
  }
  func isLoggedIn() -> Bool {
    return StoreHelper.isLoggedUser()
  }
  func setUserName(name: String) {
    set(name, forKey: UserDefaultsKeys.userName.rawValue)
    synchronize()
  }
  func getUserName() -> String? {
    return string(forKey: UserDefaultsKeys.userName.rawValue)
  }
  func setCookie(_ cookie: String?) {
    set(cookie, forKey: UserDefaultsKeys.cookieValue.rawValue)
    synchronize()
  }
  func getCookie() -> String? {
    return StoreHelper.getCookie()?.values.first
  }
}
