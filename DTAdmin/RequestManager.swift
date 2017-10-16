//
//  RequestManager.swift
//  DTAdmin
//
//  Created by Володимир on 10/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class RequestManager<T>{
    
    let urlProtocol = "http://"
    let urlDomain = "vps9615.hyperhost.name"
    let urlLogin = "/login/index"
    let urlStudents = "/student/getRecords"
    private var entityType: T?
    
    var cookie: HTTPCookie? {
        let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
        for cookieItem:HTTPCookie in cookies as [HTTPCookie] {
            if cookieItem.domain == self.urlDomain {
                return cookieItem
            }
        }
        return nil
    }
    
    func getLoginData(for userName: String, password: String, returnResults: @escaping (_ responseUser: DataStructures.User?, _ cookies: HTTPCookie?, _ error: String?) -> ()) {
        let parameters = ["username":userName,"password":password]
        var request = URLRequest(url: URL(string: urlProtocol + urlDomain + urlLogin)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var logedUser: DataStructures.User?
            var errorMsg: String?
            guard let responseValue = response as? HTTPURLResponse else {return}
            if let error = error {
                errorMsg = error.localizedDescription
            } else {
                if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                    guard let data = data else { return }
                    do {
                        logedUser = try JSONDecoder().decode(DataStructures.User.self, from: data)
                    } catch {
                        errorMsg = "Incorrect data structure!"
                    }
                } else {
                    errorMsg = "No such user or bad password!"
                }
                DispatchQueue.main.async {
                    returnResults( logedUser, self.cookie, errorMsg)
                }
            }
        }.resume()
    }
    
    func getEntityList<T>(byStructure: Entities, returnResults: @escaping (_ list: [T]?) -> ()) {
        
        let commandInUrl = "/"+byStructure.rawValue+"/getRecords"
        guard let url = URL(string: urlProtocol+urlDomain+commandInUrl) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        request.setValue("session=\(cookie)", forHTTPHeaderField: "Cookie")
        let getSession = URLSession.shared
        getSession.dataTask(with: request) { (data, response, error) in
            if let sessionError = error {
                print(error)
            } else {
                
            }
        }
        //ent.self
    }
    
}
