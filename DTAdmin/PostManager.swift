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
    
    let urlPrepare: [TypeReqest:(command:String,method:String)] = [.InsertData:("/insertData","POST"),.GetRecords:("/getRecords","GET"), .UpdateData:("/update/","POST"), .Delete:("/del/","GET")]
    
    enum TypeReqest {
        case InsertData
        case GetRecords
        case UpdateData
        case Delete
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
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String = "") -> URLRequest?{
        guard let URLCreationData = urlPrepare[type] else {return nil}
        let commandInUrl = "/"+entityStructure.rawValue+URLCreationData.command + id
        guard let url = URL(string: urlProtocol+urlDomain+commandInUrl) else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = URLCreationData.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        if let selfCookie = self.cookie {
            request.setValue("session=\(selfCookie.value)", forHTTPHeaderField: "Cookie")
        }
        return request
    }
    
    
    
}
