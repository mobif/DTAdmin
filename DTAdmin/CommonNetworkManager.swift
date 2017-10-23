//
//  NetworkManager.swift
//  DTAdmin
//
//  Created by mac6 on 10/19/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct Keys {
    static let ID_KEY = "id"
    static let USER_NAME_KEY = "username"
    static let PASSWORD_KEY = "password"
    static let ROLES_KEY = "roles"
    static let COOKIE_KEY = "Cookie"
}

struct API {
    static let AccessProtocol = "http://"
    static let DomainURL = "vps9615.hyperhost.name"
    static let LoginURL = URL(string: AccessProtocol + DomainURL + "/login/index")
    static let TimeTableForGroupURL = URL(string: AccessProtocol + DomainURL + "/timeTable/getTimeTablesForGroup")
    static let TimeTableURL = URL(string: AccessProtocol + DomainURL + "/timeTable")
}

enum HttpMehtod: String {
    case GET = "GET"
    case POST = "POST"
}

class CommonNetworkManager {

    private static var sharedNetworkManager: CommonNetworkManager = {
        let networkManager = CommonNetworkManager()
        return networkManager
    }()

    var baseURL: URL
    private init() {
        self.baseURL = API.LoginURL!
    }

    class func shared() -> CommonNetworkManager {
        return sharedNetworkManager
    }
    
    func logIn(username: String, password: String, completionHandler: @escaping (_ user: User?, _ error: Error?) -> ()){
        let parameters = [Keys.USER_NAME_KEY: username, Keys.PASSWORD_KEY: password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        let url = API.LoginURL
        var request = URLRequest(url: url!)
        request.httpBody = httpBody
        request.httpMethod = HttpMehtod.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8", forHTTPHeaderField: "Charset")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                print(error)
            } else {
                if let response = response as? HTTPURLResponse, let data = data {
                    if response.statusCode == 200 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                            let user = User(json: json ?? [String: Any]())
                            HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
                                if cookie.domain == API.DomainURL {
                                    StoreHelper.setCookie(cookie: cookie)
                                }
                            })
                            completionHandler(user, nil)
                        } catch {
                            print(error)
                        }
                    } else {
                        print(response)
                    }
                }
            }
            }.resume()
    }
    
    func timeTable(by groupID: Int, completion: @escaping (_ timesTable: [TimeTable]?, _ error: Error?) -> ()) {
        var request = URLRequest(url: (API.TimeTableForGroupURL?.appendingPathComponent("group_id=\"\(groupID)\""))!)
        request.httpMethod = HttpMehtod.GET.rawValue
        if let cookies = StoreHelper.getCookie() {
            request.setValue(cookies[Keys.COOKIE_KEY], forHTTPHeaderField: Keys.COOKIE_KEY)
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let response = response as? HTTPURLResponse, let data = data {
                    if response.statusCode == 200 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                            print(json)
                            completion([TimeTable](), nil)
                        } catch {
                            print(error)
                        }
                    } else {
                        print(response)
                    }
                }
            }
            }.resume()
    }
    
    func timeTable(completion: @escaping (_ timeTableArr: [TimeTable]?, _ error: Error?) -> ()) {
        var request = URLRequest(url: (API.TimeTableURL?.appendingPathComponent("/getRecords"))!)
        request.httpMethod = HttpMehtod.GET.rawValue
        if let cookies = StoreHelper.getCookie() {
            request.setValue(cookies[Keys.COOKIE_KEY], forHTTPHeaderField: Keys.COOKIE_KEY)
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let response = response as? HTTPURLResponse, let data = data {
                    if response.statusCode == 200 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                            var timeTableArr = [TimeTable]()
                            json?.forEach({ (timeTableJson) in
                                let timeTable = TimeTable(json: timeTableJson)
                                timeTableArr.append(timeTable)
                            })
                            completion(timeTableArr, nil)
                        } catch {
                            print(error)
                        }
                    } else {
                        completion(nil, error)
                        print(response)
                    }
                }
            }
            }.resume()
    }
    
    func createTimeTable(timeTable: TimeTable, completion: @escaping (_ timeTable: TimeTable?, _ error: Error?) -> ()) {
        var request = URLRequest(url: (API.TimeTableURL?.appendingPathComponent("/insertData"))!)
        request.httpMethod = HttpMehtod.POST.rawValue
        if let cookies = StoreHelper.getCookie() {
            request.setValue(cookies[Keys.COOKIE_KEY], forHTTPHeaderField: Keys.COOKIE_KEY)
        }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: timeTable.jsonRepresentation, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let response = response as? HTTPURLResponse, let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                        let timeTable = TimeTable(json: json?.first)
                        completion(timeTable, nil)
                    } catch {
                        print(error)
                    }
                    if response.statusCode == 200 {
                        
                    } else {
                        print(response)
                    }
                }
            }
            }.resume()
    }
}
