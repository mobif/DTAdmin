//
//  PostManager.swift
//  DTAdmin
//
//  Created by Володимир on 10/17/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class PostManager<T: Codable>{
    let urlProtocol = "http://"
    let urlDomain = "vps9615.hyperhost.name"
    let urlLogin = "/login/index"
    let urlStudents = "/student/getRecords"
    
    let urlPrepare: [TypeReqest:(command:String,method:String)] = [.InsertData:("/insertData","POST"),.GetRecords:("/getRecordsRange","GET")]
    
    enum TypeReqest {
        case InsertData
        case GetRecords
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
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest) -> URLRequest?{
        guard let URLCreationData = urlPrepare[type] else {return nil}
        let commandInUrl = "/"+entityStructure.rawValue+URLCreationData.command
        guard let url = URL(string: urlProtocol+urlDomain+commandInUrl) else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = URLCreationData.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        return request
    }
    
    func insertEntity(entity:T, entityStructure: Entities, returnResults: @escaping (_ error: String?)->()){
        guard var request = getURLReqest(entityStructure: entityStructure, type: TypeReqest.InsertData) else {return}
        let encoder = JSONEncoder()
        do {
            let newEntityAsJSON = try encoder.encode(entity)
            request.httpBody = newEntityAsJSON
            //print(String(data:newEntityAsJSON, encoding: .utf8)!)
        } catch {
            returnResults(error.localizedDescription)
        }
        guard let selfCookie = self.cookie else {return}
        request.setValue("session=\(selfCookie.value)", forHTTPHeaderField: "Cookie")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorMsg: String?
            //print(String(data:data!, encoding: .utf8)!)
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
