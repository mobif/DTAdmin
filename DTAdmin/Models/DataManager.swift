//
//  DataManager.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/24/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class DataManager: HTTPManager {

    static let shared = DataManager()
    private override init(){}
/**
     Returns an array containing the non-nil defined type of elements from API
     - Precondition: Get list all records is not supported by API for next enitities: __Student__, __Question__, __Answer__, __User__
     - Parameters:
        - typeEntity : Type of entity from Entities enum
        - listEntity : Returns an optional array of elements type Any. Use __cast to type__ for all elements according to structure of data
        - error : Optional string in case of error while receiving data
*/
    func getList(byEntity typeEntity: Entities, completionHandler: @escaping (_ listEntity: [Any]?, _ error: String?) -> ()) {
      if typeEntity == .Student || typeEntity == .Question || typeEntity == .Answer {
            completionHandler(nil, NSLocalizedString("Request not supported.", comment: "Request not supported for entity."))
        }
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.GetRecords) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                StoreHelper.logout()
                completionHandler(nil, error)
            }
            guard let  json = list as? [[String: Any]] else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
                return
            }
            var entytiList = [Any]()
            switch typeEntity {
            case .Faculty: entytiList = json.flatMap { FacultyStructure(dictionary: $0) }
            case .Speciality: entytiList = json.flatMap { SpecialityStructure(dictionary: $0) }
            case .Group: entytiList = json.flatMap { GroupStructure(dictionary: $0) }
            case .Subject: entytiList = json.flatMap { SubjectStructure(dictionary: $0) }
            case .Test: entytiList = json.flatMap { TestStructure(dictionary: $0) }
            case .TestDetail: entytiList = json.flatMap { TestDetailStructure(dictionary: $0) }
            case .TimeTable: entytiList = json.flatMap { TimeTableStructure(dictionary: $0) }
            case .User: entytiList = json.flatMap { UserStructure(dictionary: $0)}
            default:
                DispatchQueue.main.async {
                    completionHandler(nil, NSLocalizedString("Request not supported.", comment: "Request not supported for entity."))
                }
            }
            DispatchQueue.main.async {
                completionHandler(entytiList, nil)
            }
        }
    }
    private func getResponse(request: URLRequest, completionHandler: @escaping (_ list: Any?, _ error: String?) -> ()) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let sessionError = error {
                DispatchQueue.main.async {
                    completionHandler(nil, sessionError.localizedDescription)
                }
            } else {
                guard let responseValue = response as? HTTPURLResponse else {
                    let errorMsg = NSLocalizedString("Incorect server response!", comment: "Incorect server response!")
                    DispatchQueue.main.async {
                        completionHandler(nil, errorMsg)
                    }
                    return
                }
                guard let sessionData = data else {
                    let errorMsg = NSLocalizedString("Response is empty", comment: "No data in server response")
                    DispatchQueue.main.async {
                        completionHandler(nil, errorMsg)
                    }
                    return
                }
                //JSON Serialization
                var json: Any
                do {
                    json = try JSONSerialization.jsonObject(with: sessionData, options: [])
                    
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                        completionHandler(json, nil)
                    } else {
                        var errorMsg: String = ""
                        if let errorReason = json as? [String: String]  {
                            guard let errorServerMsg = errorReason["response"] else { return }
                            errorMsg = errorServerMsg
                        }
                        errorMsg = NSLocalizedString("Error response: \(responseValue.statusCode) - \(errorMsg)", comment: "Incorrect request")
                        completionHandler(nil, errorMsg)
                    }
                }
            }
        }.resume()
    }
    
    func getListRange(forEntity typeEntity: Entities, fromNo index: UInt, quantity:UInt, completionHandler: @escaping (_ listEntity: [Any]?, _ error: String?) -> ()) {
        getCountItems(forEntity: typeEntity) { (count, error) in
            if let errorExists = error  {
                completionHandler(nil, errorExists)
            }
            guard let count = count else {
                completionHandler(nil, NSLocalizedString("Uncountable list of Entity", comment: "Uncountable list of Entity or response is incorrect"))
                return
            }
            if index + quantity > count {
                completionHandler(nil, NSLocalizedString("Out of Bounds", comment: "Out of Bounds"))
            }
            var indexString: String
            var quantityString: String
            if index + quantity == 0 {
                quantityString = String(count)
            } else {
                quantityString = String(quantity)
            }
            indexString = String(index)
            guard let request = self.getURLReqest(entityStructure: typeEntity, type: TypeReqest.GetRecordsRange, limit: quantityString, offset: indexString) else {
                let error = "Cannot prepare header for URLRequest"
                completionHandler(nil, error)
                return
            }
            self.getResponse(request: request) { (list, error) in
                if let error = error {
                    StoreHelper.logout()
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
                guard let  json = list as? [[String: Any]] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completionHandler(nil, error)
                    return
                }
                var entytiList = [Any]()
                switch typeEntity {
                case .Faculty: entytiList = json.flatMap { FacultyStructure(dictionary: $0) }
                case .Speciality: entytiList = json.flatMap { SpecialityStructure(dictionary: $0) }
                case .Group: entytiList = json.flatMap { GroupStructure(dictionary: $0) }
                case .Subject: entytiList = json.flatMap { SubjectStructure(dictionary: $0) }
                case .Test: entytiList = json.flatMap { TestStructure(dictionary: $0) }
                case .TestDetail: entytiList = json.flatMap { TestDetailStructure(dictionary: $0) }
                case .TimeTable: entytiList = json.flatMap { TimeTableStructure(dictionary: $0) }
                case .Question: entytiList = json.flatMap { QuestionStructure(dictionary: $0) }
                case .Answer: entytiList = json.flatMap { AnswerStructure(dictionary: $0) }
                case .Student: entytiList = json.flatMap { StudentStructure(dictionary: $0) }
                case .User: entytiList = json.flatMap { UserStructure(dictionary: $0) }
                }
                DispatchQueue.main.async {
                    completionHandler(entytiList, nil)
                }
            }
        }
    }
    
    func getEntity(byId: String, typeEntity: Entities, completionHandler: @escaping (_ entity: Any?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.GetOneRecord, id: byId) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            DispatchQueue.main.async {
                completionHandler(nil, error)
            }
            return
        }
        getResponse(request: request) { (entity, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            guard let entity = entity else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
                return
            }
            guard let  jsonArray = entity as? [[String: Any]] else {
                completionHandler(nil, NSLocalizedString("Structure is incorrect: \(entity)", comment: "Response unrelated to structure"))
                return
            }
            guard let json = jsonArray.first else {
                completionHandler(nil, NSLocalizedString("Response is empty: \(jsonArray)", comment: "Response is empty"))
                return
            }
            var entityInstance: Any?
            switch typeEntity {
            case .Faculty: entityInstance = FacultyStructure(dictionary: json)
            case .Speciality: entityInstance = SpecialityStructure(dictionary: json)
            case .Group: entityInstance = GroupStructure(dictionary: json)
            case .Subject: entityInstance = SubjectStructure(dictionary: json)
            case .Test: entityInstance = TestStructure(dictionary: json)
            case .TestDetail: entityInstance = TestDetailStructure(dictionary: json)
            case .TimeTable: entityInstance = TimeTableStructure(dictionary: json)
            case .Question: entityInstance = QuestionStructure(dictionary: json)
            case .Answer: entityInstance = AnswerStructure(dictionary: json)
            case .Student: entityInstance = StudentStructure(dictionary: json)
            case .User: entityInstance = UserStructure(dictionary: json)
            }
            guard let entityUnwraped = entityInstance else {
                completionHandler(nil, NSLocalizedString("Incorrect type", comment: "Incorrect type"))
                return
            }
            DispatchQueue.main.async {
                completionHandler(entityUnwraped, nil)
            }
        }
    }
    
    func getCountItems(forEntity: Entities, completion: @escaping (_ count: UInt?, _ Error: String?) -> () ) {
        guard let request = getURLReqest(entityStructure: forEntity, type: TypeReqest.GetCount) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completion(nil, error)
            return
        }
        getResponse(request: request) { (response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                guard let responseUnwraped = response else { return }
                guard let  json = responseUnwraped as? [String: Any] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completion(nil, error)
                    return
                }
                // MARK: Debug part
                guard let countString = json["numberOfRecords"] as? String else {
                    let errorMsg = NSLocalizedString("Incorect server response!", comment: "Incorect server response!")
                    completion(nil, errorMsg)
                    return
                }
                guard let count = UInt(countString) else {
                    let errorMsg = NSLocalizedString("Incorect server response!", comment: "Incorect server response!")
                    completion(nil, errorMsg)
                    return
                }
                completion(count, nil)
            }
        }
    }

    func updateEntity<TypeEntity: Serializable>(byId: String, entity: TypeEntity, typeEntity: Entities, completionHandler: @escaping (_ error: String?) -> ()) {
        guard var request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.UpdateData, id: byId) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(error)
            return }
        let postData = entity.dictionary
        do {
            let json = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = json
        } catch {
            completionHandler(error.localizedDescription)
        }
        getResponse(request: request) { (entity, error) in
            if let error = error {
                completionHandler(error)
            } else {
                guard let entityUnwraped = entity else { return }
                guard let json = entityUnwraped as? [String: Any] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completionHandler(error)
                    return
                }
                // MARK: Debug part
                completionHandler(nil)
            }
            completionHandler(nil)
        }
    }
    func insertEntity<TypeEntity: Serializable>(entity: TypeEntity, typeEntity: Entities, completionHandler: @escaping (_ confirmation: Any?, _ error: String?) -> ()) {
        guard var request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.InsertData) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return }
        let postData = entity.dictionary
        do {
            let json = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = json
        } catch {
            completionHandler(nil, error.localizedDescription)
        }
        getResponse(request: request) { (entity, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                guard let entity = entity else { return }
                switch typeEntity {
                case .Student, .User:
                    guard let  json = entity as? [String: Any] else {
                        let errorMsg = NSLocalizedString("Response is empty: \(entity)", comment: "No data in server response")
                        completionHandler(nil, errorMsg)
                        return
                    }
                    // MARK: Debug part
                    completionHandler(json["id"], nil)
                default:
                    guard let  json = entity as? [[String: Any]] else {
                        let errorMsg = NSLocalizedString("Response is empty: \(entity)", comment: "No data in server response")
                        completionHandler(nil, errorMsg)
                        return
                    }
                    completionHandler(json, nil)
                }
            }
        }
    }
    
    func deleteEntity(byId: String, typeEntity: Entities, completionHandler: @escaping (_ confirmation: Any?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.Delete, id: byId) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return }
        getResponse(request: request) { (entity, error) in
            if let error = error {
                
                    completionHandler(nil, error)
                
            } else {
                guard let entity = entity else { return }
                guard let  json = entity as? [String: String] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completionHandler(nil, error)
                    return
                }
                // MARK: Debug part
                if json["response"] == "ok" {
                    completionHandler("ok", nil)
                } else {
                    completionHandler(nil, json["response"])
                }
            }
        }
    }
    //The function returns list Students for defined group, in records excluded image data
    func getStudents(forGroup group: String, withoutImages: Bool, completionHandler: @escaping (_ students: [StudentStructure]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: .Student, type: TypeReqest.GetStudentsByGroup, id: group, withoutImages: withoutImages) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            guard let  json = list as? [[String: Any]] else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
                return
            }
            let studentList = json.flatMap { StudentStructure(dictionary: $0) }
            DispatchQueue.main.async {
                completionHandler(studentList, nil)
            }
        }
    }
    
    func getGroups(bySpeciality speciality: String, completionHandler: @escaping (_ groups: [GroupStructure]?, _ error: String?) -> ()) {
        getList(byID: speciality, type: .GetGroupBySpeciality, entityStructure: .Group) {
            (list, error) in
            let groupList = list as? [GroupStructure]
            completionHandler( groupList, nil)
        }
    }
    func getGroups(byFaculty faculty: String, completionHandler: @escaping (_ groups: [GroupStructure]?, _ error: String?) -> ()) {
        getList(byID: faculty, type: .GetGroupByFaculty, entityStructure: .Group) {
            (list, error) in
            let groupList = list as? [GroupStructure]
            completionHandler( groupList, nil)
        }
    }
    func getTestDetails(byTest test: String, completionHandler: @escaping (_ testDetails: [TestDetailStructure]?, _ error: String?) -> ()) {
        getList(byID: test, type: .GetTestDetailsByTest, entityStructure: .TestDetail) {
            (list, error) in
            let testList = list as? [TestDetailStructure]
            completionHandler( testList, nil)
        }
    }
    func getTest(bySubject subject: String, completionHandler: @escaping (_ tests: [TestStructure]?, _ error: String?) -> ()) {
        getList(byID: subject, type: .GetTestsBySubject, entityStructure: .Test) {
            (list, error) in
            let testList = list as? [TestStructure]
            completionHandler( testList, nil)
        }
    }
    
    func getTimeTables(forGroup group: String, completionHandler: @escaping (_ tables: [TimeTableStructure]?, _ error: String?) -> ()) {
        getList(byID: group, type: .GetTimeTablesForGroup, entityStructure: .TimeTable) {
            (list, error) in
            let timeTables = list as? [TimeTableStructure]
            completionHandler( timeTables, nil)
        }
    }
    func getTimeTables(forSubject subject: String, completionHandler: @escaping (_ tables: [TimeTableStructure]?, _ error: String?) -> ()) {
        getList(byID: subject, type: .GetTimeTablesForSubject, entityStructure: .TimeTable) {
            (list, error) in
            let timeTables = list as? [TimeTableStructure]
            completionHandler( timeTables, nil)
        }
    }
    
    private func getList(byID: String, type: TypeReqest, entityStructure: Entities, completionHandler: @escaping (_ list: [Any]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: entityStructure, type: type, id: byID) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            guard let  json = list as? [[String: Any]] else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
                return
            }
            var listAny: [Any]?
            switch entityStructure {
            case .TestDetail: listAny = json.flatMap { TestDetailStructure(dictionary: $0) }
            case .Group: listAny = json.flatMap { GroupStructure(dictionary: $0) }
            case .Test: listAny = json.flatMap { TestStructure(dictionary: $0) }
            case .TimeTable: listAny = json.flatMap { TimeTableStructure(dictionary: $0) }
            default: completionHandler(nil, NSLocalizedString("Request not supported!", comment: "Request not supported!"))
            }
            DispatchQueue.main.async {
                completionHandler(listAny, nil)
            }
        }
    }
}


