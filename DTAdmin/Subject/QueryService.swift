//
//  QueryService.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class QueryService {
    
    typealias QueryResult = ([Subject]?, Int, String) -> ()
    var records: [Subject] = []
    var statusCode: Int = 0
    var errorMessage = ""
    
    let basePath = "http://vps9615.hyperhost.name/"
    
    func postRequests(parameters: [String : String], sufix: String, completion: @escaping QueryResult) {
        
        guard let url = URL(string: basePath + sufix) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(nil, 0, self.errorMessage)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.updateSearchResults(data)
                self.statusCode = response.statusCode
                DispatchQueue.main.async {
                    completion(self.records, self.statusCode, self.errorMessage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, self.statusCode, self.errorMessage)
                }
            }
          
        }
        task.resume()
        
    }

    func getRecords (sufix: String, completion: @escaping QueryResult) {
        
        guard let url = URL(string: basePath + sufix) else { return }
        var request = URLRequest(url: url)
        if let cookies = StoreHelper.getCookie() {
            request.setValue(cookies[Keys.cookie], forHTTPHeaderField: Keys.cookie)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
    
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(nil, 0, self.errorMessage)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.updateSearchResults(data)
                self.statusCode = response.statusCode
                DispatchQueue.main.async {
                    completion(self.records, self.statusCode, self.errorMessage)
                }
            }
        }
        task.resume()
    }
    
    func deleteReguest(sufix: String, completion: @escaping (Int, (String?)) ->()) {
        guard let url = URL(string: basePath + sufix) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(0, self.errorMessage)
            }
            
            guard let httpStatus = response as? HTTPURLResponse else {return}
            if httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            completion(httpStatus.statusCode, nil)
        }
        task.resume()
    }
    
    fileprivate func updateSearchResults(_ data: Data?) {
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    for trackDictionary in json {
                        if let trackDictionary = trackDictionary as? [String: Any],
                            let desc = trackDictionary["subject_description"] as? String ,
                            let id = trackDictionary["subject_id"] as? String,
                            let name = trackDictionary["subject_name"] as? String {
                            records.append(Subject(id : id, name : name, description: desc))
                        }
                    }
                }
            }
            catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
}
