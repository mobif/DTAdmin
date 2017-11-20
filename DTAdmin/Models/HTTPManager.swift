//
//  HTTPManager.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class HTTPManager: HTTPHeaderPreparable {
    let urlProtocol = "http://"
    let urlDomain = "vps9615.hyperhost.name"
    
    let urlPrepare: [TypeReqest: (command: String, method: String)] = [TypeReqest.insertData: ("/insertData", "POST"),
                                .getRecords: ("/getRecords", "GET"),
                                .updateData: ("/update/", "POST"),
                                .delete: ("/del/", "GET"),
                                .getOneRecord: ("/getRecords/", "GET"),
                                .getCount: ("/countRecords", "GET"),
                                .getRecordsRange: ("/getRecordsRange", "GET"),
                                .getStudentsByGroup: ("/getStudentsByGroup/", "GET"),
                                .getGroupBySpeciality: ("/getGroupsBySpeciality/", "GET"),
                                .getGroupByFaculty: ("/getGroupsByFaculty/", "GET"),
                                .getTestDetailsByTest: ("/getTestDetailsByTest/", "GET"),
                                .getTestsBySubject: ("/getTestsBySubject/", "GET"),
                                .getTimeTablesForGroup: ("/getTimeTablesForGroup/", "GET"),
                                .getTimeTablesForSubject: ("/getTimeTablesForSubject/", "GET"),
                                .getQuestionsByLevelRand: ("/getQuestionsByLevelRand/", "GET"),
                                .getQuestionIdsByLevelRand: ("/getQuestionIdsByLevelRand/", "GET"),
                                .getAnswersByQuestion: ("/getAnswersByQuestion/", "GET"),
                                .countRecordsByTest: ("/countRecordsByTest/", "GET"),
                                .getRecordsRangeByTest: ("/getRecordsRangeByTest/", "GET") ]
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String = "", limit: String = "",
                      offset: String = "", withoutImages: Bool = false) -> URLRequest? {
        guard let URLCreationData = urlPrepare[type] else { return nil }
        let withImages = withoutImages ? "/without_images" : ""
        let rangeString = (limit != "" && offset != "") ? "/\(limit)/\(offset)" : ""
        let commandInUrl = "/" + entityStructure.rawValue + URLCreationData.command + id + rangeString + withImages
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
    func getURLReqest(entityStructure: Entities, type: TypeReqest) -> URLRequest? {
        return getURLReqest(entityStructure: entityStructure, type: type, id: "", limit: "", offset: "",
                            withoutImages: false)
    }
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest, limit: String, offset: String) -> URLRequest? {
        return getURLReqest(entityStructure: entityStructure, type: type, id: "", limit: limit, offset: offset,
                            withoutImages: false)
    }
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String) -> URLRequest? {
        return getURLReqest(entityStructure: entityStructure, type: type, id: id, limit: "", offset: "",
                            withoutImages: false)
    }
    
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String, withoutImages: Bool) -> URLRequest? {
        return getURLReqest(entityStructure: entityStructure, type: type, id: id, limit: "", offset: "",
                            withoutImages: withoutImages)
    }
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String, limit: String,
                      offset: String) -> URLRequest? {
        return getURLReqest(entityStructure: entityStructure, type: type, id: id, limit: limit, offset: offset)
    }
}
