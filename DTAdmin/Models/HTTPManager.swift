//
//  HTTPManager.swift
//  DTAdmin
//
//  Created by Володимир on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class HTTPManager {
    let urlProtocol = "http://"
    let urlDomain = "vps9615.hyperhost.name"
    
    enum TypeReqest {
        case InsertData
        case GetRecords
        case UpdateData
        case Delete
        case GetOneRecord
    }
    let urlPrepare: [TypeReqest: (command: String,method: String)] = [.InsertData: ("/insertData", "POST"), .GetRecords: ("/getRecords", "GET"), .UpdateData: ("/update/", "POST"), .Delete: ("/del/", "GET"), .GetOneRecord: ("/getRecords/", "GET")]
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String = "") -> URLRequest? {
        guard let URLCreationData = urlPrepare[type] else { return nil }
        let commandInUrl = "/" + entityStructure.rawValue + URLCreationData.command + id
        guard let url = URL(string: urlProtocol + urlDomain + commandInUrl) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = URLCreationData.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("UTF-8", forHTTPHeaderField: "Charset")
        if let cookies = StoreHelper.getCookie() {
            request.setValue(cookies[Keys.cookie], forHTTPHeaderField: Keys.cookie)
        }
        return request
    }
}
