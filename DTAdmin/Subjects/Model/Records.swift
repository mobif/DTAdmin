//
//  Records.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation.NSURL

struct Records: Decodable {
    let id: String
    let name: String
    let description: String
    
    init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    static let basePath = "http://vps9615.hyperhost.name/subject/"
    
    static func getRecords (sufix: String, completion: @escaping ([Records]?) -> ()) {
        
        let url = basePath + sufix
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var recordsArray:[Records] = []
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        for trackDictionary in json {
                            if let trackDictionary = trackDictionary as? [String: Any],
                                let desc = trackDictionary["subject_description"] as? String ,
                                let id = trackDictionary["subject_id"] as? String,
                                let name = trackDictionary["subject_name"] as? String {
                                recordsArray.append(Records(id : id, name : name, description: desc))
                            }
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                completion(recordsArray)
            }
        }
        task.resume()
    }
}

