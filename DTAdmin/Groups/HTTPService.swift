//
//  HTTPService.swift
//  DTAdmin
//
//  Created by Kravchuk on 18.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class HTTPService {
    
    static let hostUrl = "http://vps9615.hyperhost.name/"
    
    static func login (completion: @escaping (HTTPURLResponse) -> ()) {
        let params = ["username": "admin", "password": "dtapi_admin"]
        let urlString = hostUrl + "login/index"
        guard let url = URL(string: urlString) else {
            print("wrong login URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "Charset")
        let jsonData:Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            print("could not serialize JSON while logining")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("statusCode is not 200 while logining")
                return }
            print(response.statusCode)
            completion(response)
            let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
            UserDefaults.standard.set((cookies.first?.value), forKey: "session")
        }
        task.resume()
    }
    
    static func getAllData (entityName:String,completion: @escaping ([[String:String]],HTTPURLResponse) -> ()) {
        let sessionValue =  UserDefaults.standard.object(forKey: "session")
        let urlString = hostUrl + entityName + "/getRecords"
        guard let url = URL(string: urlString) else {
            print("wrong get URL for \(entityName)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "Charset")
        request.setValue("session=\(sessionValue ?? "")", forHTTPHeaderField: "Cookie")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            print("data = \(String(describing: data))")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("statusCode is not 200 while geting data with \(entityName)")
                    return
                }
                completion(json!, response)
            } catch {
                print("could not serialize JSON while geting data with \(entityName)")
                return
            }
        }
        task.resume()
    }
    
    static func getData (entityName:String,id:String,completion: @escaping ([String:String],HTTPURLResponse) -> ()) {
        let sessionValue =  UserDefaults.standard.object(forKey: "session")
        let urlString = hostUrl + entityName + "/getRecords/" + id
        guard let url = URL(string: urlString) else {
            print("wrong get URL for \(entityName)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "Charset")
        request.setValue("session=\(sessionValue ?? "")", forHTTPHeaderField: "Cookie")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            print("data = \(String(describing: data))")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:String]
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("statusCode is not 200 while geting data with \(entityName) id \(id)")
                    return
                }
                completion(json!, response)
            } catch {
                print("could not serialize JSON while geting data with \(entityName) id \(id)")
                return
            }
        }
        task.resume()
    }
    
    static func postData (entityName:String,postData:[String:String],completion: @escaping (HTTPURLResponse, [[String:String]]) -> ()) {
        let sessionValue =  UserDefaults.standard.object(forKey: "session")
        let urlString = hostUrl + entityName + "/insertData"
        guard let url = URL(string: urlString) else {
            print("wrong post URL for \(entityName)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "Charset")
        request.setValue("session=\(sessionValue ?? "")", forHTTPHeaderField: "Cookie")
        print(sessionValue ?? "no session")
        do {
            let json = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = json
        } catch {
            print("could not serialize JSON while writing data with \(entityName)")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            var jsonData = [[String:String]]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
                if json != nil {
                    jsonData = json!
                }
            } catch {
                print("could not serialize data to JSON with \(entityName)")
            }
            
            print("data = \(String(describing: data))")
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("statusCode is not 200 while writing data with \(entityName)")
                return
            }
            completion(response,jsonData)
        }
        task.resume()
    }
    
    static func putData (entityName:String,id:String,postData:[String:String],completion: @escaping (HTTPURLResponse, [[String:String]]) -> ()) {
        let sessionValue =  UserDefaults.standard.object(forKey: "session")
        let urlString = hostUrl + entityName + "/update/" + id
        guard let url = URL(string: urlString) else {
            print("wrong post URL for \(entityName)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "Charset")
        request.setValue("session=\(sessionValue ?? "")", forHTTPHeaderField: "Cookie")
        do {
            let json = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = json
        } catch {
            print("could not serialize JSON while writing data with \(entityName) id \(id)")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            var jsonData = [[String:String]]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
                if json != nil {
                    jsonData = json!
                }
            } catch {
                print("could not serialize data to JSON with \(entityName)")
            }
            print("data = \(String(describing: data))")
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("statusCode is not 200 while writing data with \(entityName) id \(id)")
                return
            }
            completion(response,jsonData)
        }
        task.resume()
    }
    
    static func deleteData (entityName: String, id: String, completion: @escaping (HTTPURLResponse) ->()){
        let sessionValue = UserDefaults.standard.object(forKey: "session") as! String
        let urlString = hostUrl + entityName + "/del/" + id
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "Charset")
        request.setValue("session=\(sessionValue)", forHTTPHeaderField: "Cookie")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            var jsonData = [String:String]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:String]
                if json != nil {
                    jsonData = json!
                }
            } catch {
                print("could not serialize data to JSON with \(entityName)")
            }
            print(jsonData)
            print("data = \(String(describing: data))")
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("statusCode is not 200 while deleting data with \(entityName) id \(id)")
                return
            }
            completion(response)
        }
        task.resume()
    }
}

