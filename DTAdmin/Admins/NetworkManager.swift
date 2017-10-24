//
//  NetworkManager.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import Foundation

class NetworkManager {
  
  private enum Urls: String {
    case protocolPrefix = "http://"
    case toHost = "vps9615.hyperhost.name"
    case suffixToUserLogIn = "/login/index"
    case suffixToUserLogOut = "/login/logout"
    case suffixToAdmins = "/AdminUser"
    case suffixToGetRecords = "/getRecords"
    case suffixToInsertData = "/insertData"
    case suffixToUpdateRecord = "/update"
    case suffixToDeleteRecord = "/del"
//  concat += </id> to update || delete exact record Exp route -> ./../entity/del/<id>
  }
  
  private enum Credentials: String {
    case userName = "username"
    case password = "password"
    case passwordConfirm = "password_confirm"
  }
  
  private func cooikiesGetter(from hostUrl: String) -> [HTTPCookie] {
    let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
    return cookies
  }
  
  private func requestBasic(with url: URL, method: String) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("utf-8", forHTTPHeaderField: "Charset")
    return request
  }
  
  private func requestBasicWithBody(httpBody: Data, url: URL, method: String) -> URLRequest {
    var request = requestBasic(with: url, method: method)
    request.httpBody = httpBody
    return request
  }
  
  private func requestWithCookie(url: URL, method: String) -> URLRequest? {
    if UserDefaults.standard.isLoggedIn(), let cookieValue = UserDefaults.standard.getCookie() {
      var request = requestBasic(with: url, method: method)
      request.setValue("session=\(cookieValue)", forHTTPHeaderField: "Cookie")
      return request
    }
    return nil
  }
  
  private func requestWithCookie(and body: Data, url: URL, method: String) -> URLRequest? {
    if var request = requestWithCookie(url: url, method: method) {
      request.httpBody = body
      return request
    } else { return nil }
  }
  
  func logIn(username: String, password: String, completionHandler: @escaping (_ user: UserModel.Admin, _ cookie: String) -> ()) {
    let credentials = [Credentials.userName.rawValue: username, Credentials.password.rawValue: password]
//    FIXME: in case JSONSerialization returns error we will not know about it
    guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: []) else { return }
    guard let url = URL(string: Urls.protocolPrefix.rawValue + Urls.toHost.rawValue + Urls.suffixToUserLogIn.rawValue) else { return }
    let request = requestBasicWithBody(httpBody: httpBody, url: url, method: "POST")
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let sessionError = error {
        print(sessionError)
      } else {
        if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
          if sessionResponse.statusCode == 200 {
            do {
              let user = try JSONDecoder().decode(UserModel.Admin.self, from: sessionData)
              DispatchQueue.main.sync {
                if let cookie = self.cooikiesGetter(from: Urls.toHost.rawValue).first?.value {
                  UserDefaults.standard.setUserName(name: user.username)
                  UserDefaults.standard.setCookie(cookie)
                  UserDefaults.standard.setLoggedIn(to: true)
                  completionHandler(user, cookie)
                }
              }
            } catch {
              print(error)
            }
          } else { print(sessionResponse) }
        }
      }
      }.resume()
  }
  
  func logOut() {
    if UserDefaults.standard.isLoggedIn(), let url = URL(string: Urls.protocolPrefix.rawValue + Urls.toHost.rawValue + Urls.suffixToUserLogOut.rawValue) {
      guard let request = requestWithCookie(url: url, method: "GET") else { return }
      
      let sessionGet = URLSession.shared
      sessionGet.dataTask(with: request) { (data, response, error) in
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
                UserDefaults.standard.setCookie(nil)
              }
            } catch {
              print(error)
            }
          }
        }
        }.resume()
    }
  }
  
  func getAdmins(completionHandler: @escaping (_ user: [UserModel.Admins]) -> ()) {
    if UserDefaults.standard.isLoggedIn(), let url = URL(string: Urls.protocolPrefix.rawValue + Urls.toHost.rawValue + Urls.suffixToAdmins.rawValue + Urls.suffixToGetRecords.rawValue) {
      guard let request = requestWithCookie(url: url, method: "GET") else { return }
      
      let getSession = URLSession.shared
      getSession.dataTask(with: request) { (data, response, error) in
        if let sessionError = error {
          print(sessionError)
        } else {
          if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
            print(sessionResponse.statusCode)
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
  
  func createAdmin(username: String, password: String, email: String)  {
    if let url = URL(string: Urls.protocolPrefix.rawValue + Urls.toHost.rawValue + Urls.suffixToAdmins.rawValue + Urls.suffixToInsertData.rawValue) {
      let newAdmin = UserModel.NewAdmin(userName: username, password: password, email: email)
      guard let httpBody = try? JSONSerialization.data(withJSONObject: newAdmin.dictionaryRepresentation, options: []) else { return }
      guard let request = requestWithCookie(and: httpBody, url: url, method: "POST") else { return }
      
      let postSession = URLSession.shared
      postSession.dataTask(with: request) { (data, response, error) in
        if let sessionError = error {
          print(sessionError)
        } else {
          if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
            if sessionResponse.statusCode == 200 {
              print("\nResponse\n", sessionResponse, "\nData\n", sessionData)
            } else { print("Something went wrong, Status code: ", sessionResponse.statusCode, sessionResponse.description)}
          }
        }
        }.resume()
    }
  }
  
  func updateAdmin(id: String, userName: String, password: String, email: String, completionHandler: @escaping (_ isCompleted: Bool) -> ()) {
    if let url = URL(string: Urls.protocolPrefix.rawValue + Urls.toHost.rawValue + Urls.suffixToAdmins.rawValue + Urls.suffixToUpdateRecord.rawValue + "/" + id) {
      let editedAdmin = UserModel.NewAdmin(userName: userName, password: password, email: email)
      guard let httpBody = try? JSONSerialization.data(withJSONObject: editedAdmin.dictionaryRepresentation, options: []) else { return }
      guard let request = requestWithCookie(and: httpBody, url: url, method: "POST") else { return }
      
      let postSession = URLSession.shared
      postSession.dataTask(with: request) { (data, response, error) in
        if let sessionError = error {
          print(sessionError)
        } else {
          if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
            if sessionResponse.statusCode == 200 {
              print("\nResponse\n", sessionResponse, "\nData\n", sessionData)
              DispatchQueue.main.async {
                completionHandler(true)
              }
            } else {
              print("Something went wrong during Update, Status code: ", sessionResponse.statusCode, sessionResponse.description)
              DispatchQueue.main.async {
                completionHandler(false)
              }
            }
          }
        }
        }.resume()
    }
  }
  
  func deleteAdmin(id: String, completionHandler: @escaping (_ isCompleted: Bool) -> ()) {
    if let url = URL(string: Urls.protocolPrefix.rawValue + Urls.toHost.rawValue + Urls.suffixToAdmins.rawValue + Urls.suffixToDeleteRecord.rawValue + "/" + id) {
      guard let request = requestWithCookie(url: url, method: "GET") else { return }
      
      let getSession = URLSession.shared
      getSession.dataTask(with: request) { (data, response, error) in
        if let sessionError = error {
          print(sessionError)
        } else {
          if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
            if sessionResponse.statusCode == 200 {
              print("\nResponse\n", sessionResponse, "\nData\n", sessionData)
              DispatchQueue.main.async {
                completionHandler(true)
              }
            } else {
              print("Something went wrong, Status code: ", sessionResponse.statusCode, sessionResponse.description)
              DispatchQueue.main.async {
                completionHandler(false)
              }
            }
          }
        }
        }.resume()
    }
  }
}

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
    return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
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
    return string(forKey: UserDefaultsKeys.cookieValue.rawValue)
  }
}
