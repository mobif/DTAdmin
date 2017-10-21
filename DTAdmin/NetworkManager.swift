//
//  NetworkManager.swift
//  DTAdmin
//
//  Created by mac6 on 10/19/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct API {
    static let loginURL = URL(string: "http://vps9615.hyperhost.name/login/index")
}

class NetworkManager {
    
    let urlProtocolPrefix = ""
    let urlToHost = ""
    let urlSuffixToUserLogIn = ""
    
    // MARK: - Properties
    
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()

    var baseURL: URL
    private init() {
        self.baseURL = API.loginURL!
    }

    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    func logIn(username: String, password: String, completionHandler: @escaping (_ user: String, _ cookie: String) -> ()){
        let credentials = ["username": username, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: []) else { return }
        let url = URL(string: "http://vps9615.hyperhost.name/login/index")
        var request = URLRequest(url: url!)
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8", forHTTPHeaderField: "Charset")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let sessionError = error {
                print(sessionError)
            } else {
                if let sessionResponse = response as? HTTPURLResponse, let sessionData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: sessionData) as? [String: Any]
                    } catch {
                        
                    }
                    if sessionResponse.statusCode == 200 {
                        do {
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        print(sessionResponse)
                    }
                }
            }
            }.resume()
    }
}
