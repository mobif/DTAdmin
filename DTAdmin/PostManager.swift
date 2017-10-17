//
//  PostManager.swift
//  DTAdmin
//
//  Created by Володимир on 10/17/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class PostManager<T: Encodable>{
    let urlProtocol = "http://"
    let urlDomain = "vps9615.hyperhost.name"
    let urlLogin = "/login/index"
    let urlStudents = "/student/getRecords"
    
    
    var cookie: HTTPCookie? {
        let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
        for cookieItem:HTTPCookie in cookies as [HTTPCookie] {
            if cookieItem.domain == self.urlDomain {
                return cookieItem
            }
        }
        return nil
    }
    func insertEntity(entity:T, entityStructure: Entities, returnResults: @escaping (_ error: String?)->()){
        let commandInUrl = "/"+entityStructure.rawValue+"/insertData"
        guard let url = URL(string: urlProtocol+urlDomain+commandInUrl) else {return}
        var request = URLRequest(url: url)
        do{
            let parameters = try JSONEncoder().encode(entity)
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print(error)
        }
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        guard let selfCookie = self.cookie else {return}
        request.setValue("session=\(selfCookie.value)", forHTTPHeaderField: "Cookie")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorMsg: String?
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
