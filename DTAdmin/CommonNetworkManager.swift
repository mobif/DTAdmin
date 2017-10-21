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
}

struct API {
    static let AccessProtocol = "http://"
    static let DomainURL = AccessProtocol + "vps9615.hyperhost.name"
    static let LoginURL = URL(string: DomainURL + "/login/index")
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
        let credentials = [Keys.USER_NAME_KEY: username, Keys.PASSWORD_KEY: password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: []) else { return }
        let url = API.LoginURL
        var request = URLRequest(url: url!)
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8", forHTTPHeaderField: "Charset")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
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
}
