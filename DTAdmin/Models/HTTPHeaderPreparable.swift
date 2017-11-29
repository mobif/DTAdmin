//
//  HTTPHeaderPreparable.swift
//  DTAdmin
//
//  Created by Володимир on 18.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

enum TypeReqest {
    case insertData
    case getRecords
    case updateData
    case delete
    case getOneRecord
    case getCount
    case getRecordsRange
    case getStudentsByGroup
    case getGroupBySpeciality
    case getGroupByFaculty
    case getTestDetailsByTest
    case getTestsBySubject
    case getTimeTablesForGroup
    case getTimeTablesForSubject
    case getQuestionsByLevelRand
    case getQuestionIdsByLevelRand
    case getAnswersByQuestion
    case countRecordsByTest
    case getRecordsRangeByTest
    case getRecordsByTestGroupDate
    case getResultTestIdsByGroup
}
protocol HTTPHeaderPreparable {
    func getURLRequestForTest(user: String) -> URLRequest?
    func getURLReqestForEntityManager(entityStructure: Entities,ids: [String]) -> URLRequest?
    func getURLReqest(entityStructure: Entities, type: TypeReqest) -> URLRequest?
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String) -> URLRequest?
    func getURLReqest(entityStructure: Entities, type: TypeReqest, limit: String, offset: String) -> URLRequest?
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String, withoutImages: Bool) -> URLRequest?
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String, limit: String,
                      offset: String) -> URLRequest?
    func getURLReqest(entityStructure: Entities, type: TypeReqest, id: String, limit: String, offset: String,
                      withoutImages: Bool) -> URLRequest?
    func getData(json: Any) throws -> Data
    func getJSON(data: Data) throws -> Any
}
