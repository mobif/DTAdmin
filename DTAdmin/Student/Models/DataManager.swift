//
//  DataManager.swift
//  DTAdmin
//
//  Created by Володимир on 10/24/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class DataManager: HTTPManager {
    
    static let dataManager = DataManager()
    
    private override init() {
    }
    
    private let entityToArray: [Entities: Any] = [.Faculty: { FacultyStructure(dictionary: $0) }, .Speciality: { SpecialityStructure(dictionary: $0) },
    .Group: { GroupStructure(dictionary: $0) }, .Subject: { SubjectStructure(dictionary: $0) }, .Test: { TestStructure(dictionary: $0) },
    .TestDetail: { TestDetailStructure(dictionary: $0) }, .TimeTable: { TimeTableStructure(dictionary: $0) }, .Question: { QuestionStructure(dictionary: $0) },
    .Answer: { AnswerStructure(dictionary: $0) }, .Student: { StudentStructure(dictionary: $0) }]
    
    func getList(byEntity typeEntity: Entities, completionHandler: @escaping (_ listEntity: [Any]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.GetRecords) else {
            let error = "Cannot prepare header for URLRequest"
            completionHandler(nil,error)
            return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                    completionHandler(nil, error)
            }
            guard let  json = list as? [[String: Any]] else {
                print("Response is empty")
                return
            }
            var entytiList = [Any]()
            guard let definedBehave = self.entityToArray[typeEntity] as? ([String : Any]) throws -> String? else {
                print("It can't be unwraped to \(typeEntity)")
                return }
            do {
            entytiList = try json.flatMap(definedBehave)
            }
            catch {
                print("Error: \(error)")
                completionHandler(nil, error.localizedDescription)
            }
            completionHandler(entytiList, nil)
        }
    }
    
    private func getResponse(request: URLRequest, completionHandler: @escaping (_ list: Any?, _ error: String?) -> ()) {
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let sessionError = error {
                DispatchQueue.main.async {
                    completionHandler(nil, sessionError.localizedDescription)
                }
            } else {
                guard let responseValue = response as? HTTPURLResponse else {
                    let errorMsg = "Incorect server response"
                    DispatchQueue.main.async {
                        completionHandler(nil, errorMsg)
                    }
                    return
                }
                if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                    guard let sessionData = data else {
                        let errorMsg = "No data in server response"
                        DispatchQueue.main.async {
                            completionHandler(nil, errorMsg)
                        }
                        return
                    }
                    //JSON Serialization
                    do {
                        let json = try JSONSerialization.jsonObject(with: sessionData, options: [])
                        completionHandler(json, nil)
                    } catch {
                        DispatchQueue.main.async {
                            completionHandler(nil, error.localizedDescription)
                        }
                        return
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(nil, "Error response: \(responseValue.statusCode)")
                    }
                }
            }
        }.resume()
    }
    
    func getEntity(byId: String, typeEntity: Entities, completionHandler: @escaping (_ entity: Any?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.GetOneRecord, id: byId) else {
            let error = "Cannot prepare header for URLRequest"
            completionHandler(nil, error)
            return
        }
        getResponse(request: request) { (entity, error) in
            if let error = error {
                DispatchQueue.main.sync {
                    completionHandler(nil, error)
                }
            }
            guard let  json = entity as? [String: Any] else {
                print("Response is empty")
                return
            }
            var entity: Any?
            switch typeEntity {
            case .Faculty: entity = FacultyStructure(dictionary: json)
            case .Speciality: entity = SpecialityStructure(dictionary: json)
            case .Group: entity = GroupStructure(dictionary: json)
            case .Subject: entity = SubjectStructure(dictionary: json)
            case .Test: entity = TestStructure(dictionary: json)
            case .TestDetail: entity = TestDetailStructure(dictionary: json)
            case .TimeTable: entity = TimeTableStructure(dictionary: json)
            case .Question: entity = QuestionStructure(dictionary: json)
            case .Answer: entity = AnswerStructure(dictionary: json)
            case .Student: entity = StudentStructure(dictionary: json)
            case .User: entity = UserStructure(dictionary: json)
            }
            guard let entityUnwraped = entity else {
                completionHandler(nil, "Incorrect type")
                return
            }
            completionHandler(entityUnwraped, nil)
        }
    }
    
    func updateEntity<TypeEntity: Serializable>(byId: String, entity: TypeEntity, typeEntity: Entities, completionHandler: @escaping (_ error: String?) -> ()) {
        guard var request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.UpdateData, id: byId) else {
            let error = "Cannot prepare header for URLRequest"
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
                DispatchQueue.main.sync {
                    completionHandler(error)
                }
            } else {
                guard let  json = entity as? [String: Any] else {
                    print("Response is empty")
                    return
                }
                // MARK: Debug part
                print(json["id"]!)
//                DispatchQueue.main.sync {
//                    completionHandler()
//                }
            }
        }
    }
    func insertEntity<TypeEntity: Serializable>(entity: TypeEntity, typeEntity: Entities, completionHandler: @escaping (_ confirmation: Any?, _ error: String?) -> ()) {
        guard var request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.InsertData) else {
            let error = "Cannot prepare header for URLRequest"
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
                DispatchQueue.main.sync {
                    completionHandler(nil, error)
                }
            } else {
                guard let  json = entity as? [String: Any] else {
                    print("Response is empty")
                    return
                }
                // MARK: Debug part
                print(json["id"]!)
                //                DispatchQueue.main.sync {
                //                    completionHandler()
                //                }
            }
        }
    }
    
    func deleteEntity(byId: String, typeEntity: Entities, completionHandler: @escaping (_ confirmation: Any?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.Delete, id: byId) else {
            let error = "Cannot prepare header for URLRequest"
            completionHandler(nil, error)
            return }
        getResponse(request: request) { (entity, error) in
            if let error = error {
                DispatchQueue.main.sync {
                    completionHandler(nil, error)
                }
            } else {
                guard let  json = entity as? [String: Any] else {
                    print("Response is empty")
                    return
                }
                // MARK: Debug part
                print(json["id"]!)
                //                DispatchQueue.main.sync {
                //                    completionHandler()
                //                }
            }
        }
    }
    
}


