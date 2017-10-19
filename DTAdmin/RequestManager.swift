//
//  RequestManager.swift
//  DTAdmin
//
//  Created by Володимир on 10/13/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class RequestManager<T: Codable> {
    
    let urlProtocol = "http://"
    let urlDomain = "vps9615.hyperhost.name"
    let urlLogin = "/login/index"
    let urlStudents = "/student/getRecords"
    
    let urlPrepare: [TypeReqest:(command:String,method:String)] = [.InsertData:("/insertData","POST"),.GetRecords:("/getRecords","GET"), .UpdateData:("/update/","POST"), .Delete:("/del/","GET"),.GetOneRecord:("/getRecords/","GET")]
    
    enum TypeReqest {
        case InsertData
        case GetRecords
        case UpdateData
        case Delete
        case GetOneRecord
    }
    
    var cookie: HTTPCookie? {
        let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
        for cookieItem:HTTPCookie in cookies as [HTTPCookie] {
            if cookieItem.domain == self.urlDomain {
                return cookieItem
            }
        }
        return nil
    }
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String = "") -> URLRequest?{
        guard let URLCreationData = urlPrepare[type] else {return nil}
        let commandInUrl = "/"+entityStructure.rawValue+URLCreationData.command + id
        guard let url = URL(string: urlProtocol+urlDomain+commandInUrl) else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = URLCreationData.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        if let selfCookie = self.cookie {
            request.setValue("session=\(selfCookie.value)", forHTTPHeaderField: "Cookie")
        }
        return request
    }
    
    func getLoginData(for userName: String, password: String, returnResults: @escaping (_ responseUser: T?, _ cookies: HTTPCookie?, _ error: String?) -> ()) {
        let parameters = ["username":userName,"password":password]
        var request = URLRequest(url: URL(string: urlProtocol + urlDomain + urlLogin)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        print(parameters)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var logedUser: T?
            var errorMsg: String?
            guard let responseValue = response as? HTTPURLResponse else {return}
            if let error = error {
                errorMsg = error.localizedDescription
            } else {
                if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                    guard let data = data else { return }
                    do {
                        logedUser = try JSONDecoder().decode(T.self, from: data)
                    } catch {
                        errorMsg = error.localizedDescription
                    }
                } else {
                    errorMsg = "Response Error: \(responseValue.statusCode)"
                }
                DispatchQueue.main.async {
                    returnResults( logedUser, self.cookie, errorMsg)
                }
            }
        }.resume()
    }
    
    func getEntityList(byStructure: Entities, returnResults: @escaping (_ list: [T]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: byStructure, type: TypeReqest.GetRecords) else {return}
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var dataList = [T]()
            var errorMsg: String?
            print(String(data:data!, encoding: .utf8)!)
            guard let responseValue = response as? HTTPURLResponse else {return}
            if let sessionError = error {
                errorMsg = sessionError.localizedDescription
            } else {
                if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                    guard let data = data else { return }
                    do {
                        dataList = try JSONDecoder().decode([T].self, from: data)
                    } catch {
                        errorMsg = "Incorrect data structure!"
                    }
                } else {
                    errorMsg = "No such user or bad password!"
                }
                DispatchQueue.main.async {
                    returnResults( dataList, errorMsg)
                }
            }
        }.resume()
    }
    
    func getEntity(byId: String, entityStructure: Entities, returnResults: @escaping (_ entity: T?, _ error: String?)->()){
        guard let request = getURLReqest(entityStructure: entityStructure, type: TypeReqest.GetOneRecord, id: byId) else {return}
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(String(data:data!, encoding: .utf8)!)
            var entity = [T]()
            var errorMsg: String?
            guard let responseValue = response as? HTTPURLResponse else {return}
            if let sessionError = error {
                errorMsg = sessionError.localizedDescription
            } else {
                if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                    guard let data = data else { return }
                    do {
                        entity = try JSONDecoder().decode([T].self, from: data)
                    } catch {
                        errorMsg = error.localizedDescription
                    }
                } else {
                    errorMsg = "No such user or bad password!"
                }
                DispatchQueue.main.async {
                    returnResults(entity.first, errorMsg)
                }
            }
        }.resume()
    }
    func updateEntity(byId: String, entity:T, entityStructure: Entities, returnResults: @escaping (_ error: String?)->()){
        guard var request = getURLReqest(entityStructure: entityStructure, type: TypeReqest.UpdateData, id: byId) else {return}
        let encoder = JSONEncoder()
        do {
            let newEntityAsJSON = try encoder.encode(entity)
            request.httpBody = newEntityAsJSON
            print(String(data:newEntityAsJSON, encoding: .utf8)!)
        } catch {
            returnResults(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorMsg: String?
            print(String(data:data!, encoding: .utf8)!)
            guard let responseValue = response as? HTTPURLResponse else {return}
            if let error = error {
                errorMsg = error.localizedDescription
            }
            if responseValue.statusCode != HTTPStatusCodes.OK.rawValue{
                errorMsg = "Error!:\(responseValue.statusCode)"
            }
            DispatchQueue.main.async {
                returnResults(errorMsg)
            }
            }.resume()
    }
    
    func insertEntity(entity:T, entityStructure: Entities, returnResults: @escaping (_ error: String?)->()){
        guard var request = getURLReqest(entityStructure: entityStructure, type: TypeReqest.InsertData) else {return}
        let encoder = JSONEncoder()
        do {
            let newEntityAsJSON = try encoder.encode(entity)
            request.httpBody = newEntityAsJSON
            print(String(data:newEntityAsJSON, encoding: .utf8)!)
        } catch {
            returnResults(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorMsg: String?
            print(String(data:data!, encoding: .utf8)!)
            guard let responseValue = response as? HTTPURLResponse else {return}
            if let error = error {
                errorMsg = error.localizedDescription
            }
            if responseValue.statusCode != HTTPStatusCodes.OK.rawValue{
                errorMsg = "Error!:\(responseValue.statusCode)"
            }
            DispatchQueue.main.async {
                returnResults(errorMsg)
            }
            }.resume()
    }
    
    func deleteEntity(byId: String, entityStructure: Entities, returnResults: @escaping (_ error: String?)->()){
        guard let request = getURLReqest(entityStructure: entityStructure, type: TypeReqest.Delete, id: byId) else {return}
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorMsg: String?
            print(String(data:data!, encoding: .utf8)!)
            guard let responseValue = response as? HTTPURLResponse else {return}
            if let error = error {
                errorMsg = error.localizedDescription
            }
            if responseValue.statusCode != HTTPStatusCodes.OK.rawValue{
                errorMsg = "Error!:\(responseValue.statusCode)"
            }
            DispatchQueue.main.async {
                returnResults(errorMsg)
            }
            }.resume()
    }

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
