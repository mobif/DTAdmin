//
//  StoreHelper.swift
//  DTAdmin
//
//  Created by mac6 on 10/21/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class StoreHelper {
    static let loginKey = "loginKey"
    
    class func isLoggedUser() -> Bool {
        guard UserDefaults.standard.value(forKey: self.loginKey) != nil else {
            return false
        }
        return true
    }
    
    class func loginSuccessful() {
        UserDefaults.standard.setValue(true, forKey: self.loginKey)
    }
    
    class func logout() {
        UserDefaults.standard.removeObject(forKey: self.loginKey)
    }
    
    class func saveUser(user: User?) {
        if let user = user {
            self.loginSuccessful()
            UserDefaults.standard.setValue(user.id, forKey: Keys.id)
            UserDefaults.standard.setValue(user.userName, forKey: Keys.username)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getLoggedUser() -> User {
        var user = User()
        user.id = UserDefaults.standard.value(forKey: Keys.id) as? String
        user.userName = UserDefaults.standard.value(forKey: Keys.username) as? String
        
        return user
    }
    
    class func setCookie (cookie:HTTPCookie) {
        UserDefaults.standard.set(HTTPCookie.requestHeaderFields(with: [cookie]), forKey: "kCookie")
        UserDefaults.standard.synchronize()
    }
    
    class func getCookie () -> [String : String]? {
        let cookie = UserDefaults.standard.value(forKey: "kCookie") as? [String : String]
        return cookie
    }
}
