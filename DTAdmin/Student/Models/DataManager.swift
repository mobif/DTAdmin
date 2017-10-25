//
//  DataManager.swift
//  DTAdmin
//
//  Created by Володимир on 10/24/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class DataManager: HTTPManager {
   
    
    func getGroups(completionHandler: @escaping (_ listGroups: [GroupStructure]?, _ error: String?) -> ()) {
        var groups: [GroupStructure]?
        getEntityList(typeEntity: Entities.Group, completionHandler: { (list, error) in
            if let error = error {
               completionHandler(nil, error)
            }
            if let list = list {
                groups = list as? [GroupStructure]
                guard let listGroups = groups else {
                    let error = "Incorrect type of elements"
                    completionHandler(nil, error)
                    return
                }
                completionHandler(listGroups, nil)
            } else {
                let error = "No response"
                completionHandler(nil, error)
            }
        })
        
    }
    
    func getEntityList(typeEntity: Entities, completionHandler: @escaping (_ list: [Any]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.GetRecords) else {
            let error = "Cannot prepare header for URLRequest"
            completionHandler(nil,error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorMsg: String?
            if let sessionError = error {
                errorMsg = sessionError.localizedDescription
            } else {
                guard let responseValue = response as? HTTPURLResponse else {
                    errorMsg = "Incorect server response"
                    DispatchQueue.main.async {
                        completionHandler(nil, errorMsg)
                    }
                    return
                }
                if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                    guard let sessionData = data else {
                        errorMsg = "No data in server response"
                        DispatchQueue.main.async {
                            completionHandler(nil, errorMsg)
                        }
                        return
                    }
                    var json: [[String:String]]?
                    do {
                        json = try JSONSerialization.jsonObject(with: sessionData, options: []) as? [[String:String]]
                    } catch {
                        print(error)
                    }
                    switch typeEntity {
                    case .Group:
                        let groups = json?.flatMap{ GroupStructure(dictionary: $0) }
                        DispatchQueue.main.sync {
                            completionHandler(groups, nil)
                        }
                    case .Student:
                        let students = json?.flatMap{ StudentStructure(dictionary: $0) }
                        DispatchQueue.main.sync {
                            completionHandler(students, nil)
                        }
                        
                    default:
                        print("error")
                    }
                }
            }
        }.resume()
    }
}


