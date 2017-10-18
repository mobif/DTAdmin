//
//  QueryService.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class QueryService {
    
    let basePath = "http://vps9615.hyperhost.name/"
    
    func postRequests(parameters : [String : String], sufix : String, completion: @escaping (Int?) -> ()) {
        
        guard let url = URL(string: basePath + sufix) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            guard let httpStatus = response as? HTTPURLResponse else {return}
            if httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            completion(httpStatus.statusCode)
            }.resume()
        
    }
    
    func deleteReguest(sufix: String ){
        guard let url = URL(string: basePath + sufix) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            guard let _ = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            
            
            guard let httpStatus = response as? HTTPURLResponse else {return}
            if httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                
            }
        }
        task.resume()
    }
    
}

