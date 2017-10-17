//
//  NetworkManager.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import Foundation

class NetworkManager {
    let urlProtocolPrefix = "http://"
    let urlToHost = "vps9615.hyperhost.name"
    let urlSuffixToUserLogIn = "/login/index"
    let urlSuffixToUserLogOut = "/login/logout"
    let urlSuffixToAdmins = "/AdminUser"
    let urlSuffixToGetRecords = "/getRecords"
    let urlSuffixToInsertData = "/insertData"
    
//    private enum Credentials {
//        case username
//        case password
//    }
    
    private func cooikiesGetter(from hostUrl: String) -> [HTTPCookie] {
        let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
        return cookies
    }
    
    func logIn(username: String, password: String, completionHandler: @escaping (_ user: UserModel.Admin, _ cookie: String) -> ()){
        //let credentials = [Credentials.username: username, Credentials.password: password]
        let credentials = ["username": username, "password": password]
        let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: [])
        guard let url = URL(string: urlProtocolPrefix + urlToHost + urlSuffixToUserLogIn) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8", forHTTPHeaderField: "Charset")
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let sessionError = error {
                print(sessionError)
            } else {
                if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
                    print(sessionResponse)
                    do {
                        let user = try JSONDecoder().decode(UserModel.Admin.self, from: sessionData)
                        DispatchQueue.main.sync {
                            if let cookie = self.cooikiesGetter(from: self.urlToHost).first?.value {
                                completionHandler(user, cookie)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    func logOut() {
        let sessionGet = URLSession.shared
        sessionGet.dataTask(with: URL(string: urlProtocolPrefix + urlToHost + urlSuffixToUserLogOut)!) { (data, response, error) in
            if let sessionError = error {
                print(sessionError)
            } else {
                if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
                    print(sessionResponse)
                    print(sessionData)
                    do {
                        let json = try JSONSerialization.jsonObject(with: sessionData, options: [])
                        print(json)
                        DispatchQueue.main.async {
                            UserDefaults.standard.setLoggedIn(to: false)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    func getAdmins(completionHandler: @escaping (_ user: [UserModel.Admins]) -> ()) {
        if UserDefaults.standard.isLoggedIn(), let url = URL(string: self.urlProtocolPrefix + self.urlToHost + self.urlSuffixToAdmins + self.urlSuffixToGetRecords), let cookieValue = UserDefaults.standard.getCookie() {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("UTF-8", forHTTPHeaderField: "Charset")
            request.setValue("session=\(cookieValue)", forHTTPHeaderField: "Cookie")
//            request.setValue("session=pck4lhsdd48imntgulq27j06o2", forHTTPHeaderField: "Cookie")
            
            let getSession = URLSession.shared
            getSession.dataTask(with: request) { (data, response, error) in
                if let sessionError = error {
                    print(sessionError)
                } else {
                    if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
                        print(sessionResponse)
                        do {
                            let admins = try JSONDecoder().decode([UserModel.Admins].self, from: sessionData)
                            DispatchQueue.main.sync {
                                completionHandler(admins)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }.resume()
        }
    }

//    func createAdmin(username: String, password: String, email: String)  {
//        if let cookieValue = UserDefaults.standard.getCookie(), let url = URL(string: self.urlProtocolPrefix + self.urlToHost + self.urlSuffixToAdmins + self.urlSuffixToInsertData) {
//            
//            let request = URLRequest(url: url)
//            let httpBody = JSONSerialization.data(withJSONObject: <#T##Any#>, options: <#T##JSONSerialization.WritingOptions#>)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("UTF-8", forHTTPHeaderField: "Charset")
//            request.setValue("session=\(cookieValue)", forHTTPHeaderField: "Cookie")
//            
//            let postSession = URLSession.shared
//            postSession.dataTask(with: request) { (data, response, error) in
//                if let sessionError = error {
//                    print(sessionError)
//                } else {
//                    if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
//                        
//                    }
//                }
//            }.resume()
//        }
//    }
}

extension UserDefaults {
    
    private enum UserDefaultsKeys: String {
        case isLoggedIn
        case username
        case cookieValue
    }
    
    func setLoggedIn(to value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    func setUserName(name: String) {
        set(name, forKey: UserDefaultsKeys.username.rawValue)
        synchronize()
    }
    func getUserName() -> String? {
        return string(forKey: UserDefaultsKeys.username.rawValue)
    }
    func setCookie(_ cookie: String) {
        set(cookie, forKey: UserDefaultsKeys.cookieValue.rawValue)
        synchronize()
    }
    func getCookie() -> String? {
        return string(forKey: UserDefaultsKeys.cookieValue.rawValue)
    }
}
