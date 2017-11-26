//
//  DataRequestable.swift
//  DTAdmin
//
//  Created by Володимир on 18.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

protocol DataRequestable: HTTPHeaderPreparable{
    func getResponse(request: URLRequest, completionHandler: @escaping (_ list: Any?, _ error: String?) -> ())
}

extension DataRequestable {
    /**
     Returns an array containing the non-nil defined type of elements from API
     - Precondition: Get list all records is not supported by API for next enitities: __Student__, __Question__, __Answer__
     - Parameters:
     - typeEntity : Type of entity from Entities enum
     - listEntity : Returns an optional array of elements type Any. Use __cast to type__ for all elements according to structure of data
     - error : Optional string in case of error while receiving data
     */
    func getList(byEntity typeEntity: Entities, completionHandler: @escaping (_ listEntity: [Any]?,
        _ error: String?) -> ()) {
        if typeEntity == .student || typeEntity == .question || typeEntity == .answer {
            completionHandler(nil, NSLocalizedString("Request not supported.",
                                                     comment: "Request not supported for entity."))
        }
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.getRecords) else {
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
            case .faculty: entytiList = json.flatMap { FacultyStructure(dictionary: $0) }
            case .speciality: entytiList = json.flatMap { SpecialityStructure(dictionary: $0) }
            case .group: entytiList = json.flatMap { GroupStructure(dictionary: $0) }
            case .subject: entytiList = json.flatMap { SubjectStructure(dictionary: $0) }
            case .test: entytiList = json.flatMap { TestStructure(dictionary: $0) }
            case .testDetail: entytiList = json.flatMap { TestDetailStructure(dictionary: $0) }
            case .timeTable: entytiList = json.flatMap { TimeTableStructure(dictionary: $0) }
            case .user: entytiList = json.flatMap { UserStructure(dictionary: $0)}
            default:
                DispatchQueue.main.async {
                    completionHandler(nil, NSLocalizedString("Request not supported.",
                                                             comment: "Request not supported for entity."))
                }
            }
            DispatchQueue.main.async {
                completionHandler(entytiList, nil)
            }
        }
    }
    func getListRange(forEntity typeEntity: Entities, fromNo index: UInt, quantity:UInt,
                      completionHandler: @escaping (_ listEntity: [Any]?, _ error: String?) -> ()) {
        getCountItems(forEntity: typeEntity) { (count, error) in
            if let errorExists = error  {
                completionHandler(nil, errorExists)
            }
            guard let count = count else {
                completionHandler(nil, NSLocalizedString("Uncountable list of Entity",
                                                         comment: "Uncountable list of Entity is incorrect"))
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
            guard let request = self.getURLReqest(entityStructure: typeEntity, type: TypeReqest.getRecordsRange,
                                                  limit: quantityString, offset: indexString) else {
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
                case .faculty: entytiList = json.flatMap { FacultyStructure(dictionary: $0) }
                case .speciality: entytiList = json.flatMap { SpecialityStructure(dictionary: $0) }
                case .group: entytiList = json.flatMap { GroupStructure(dictionary: $0) }
                case .subject: entytiList = json.flatMap { SubjectStructure(dictionary: $0) }
                case .test: entytiList = json.flatMap { TestStructure(dictionary: $0) }
                case .testDetail: entytiList = json.flatMap { TestDetailStructure(dictionary: $0) }
                case .timeTable: entytiList = json.flatMap { TimeTableStructure(dictionary: $0) }
                case .question: entytiList = json.flatMap { QuestionStructure(dictionary: $0) }
                case .answer: entytiList = json.flatMap { AnswerStructure(dictionary: $0) }
                case .student: entytiList = json.flatMap { StudentStructure(dictionary: $0) }
                case .user: entytiList = json.flatMap { UserStructure(dictionary: $0) }
                case .result: entytiList = json.flatMap { TestResults(dictionary: $0) }
                }
                DispatchQueue.main.async {
                    completionHandler(entytiList, nil)
                }
            }
        }
    }
    
    func getEntity(byId: String, typeEntity: Entities, completionHandler: @escaping (_ entity: Any?,
        _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.getOneRecord, id: byId) else {
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
                completionHandler(nil, NSLocalizedString("Structure is incorrect: \(entity)",
                    comment: "Response unrelated to structure"))
                return
            }
            guard let json = jsonArray.first else {
                completionHandler(nil, NSLocalizedString("Response is empty: \(jsonArray)",
                    comment: "Response is empty"))
                return
            }
            var entityInstance: Any?
            switch typeEntity {
            case .faculty: entityInstance = FacultyStructure(dictionary: json)
            case .speciality: entityInstance = SpecialityStructure(dictionary: json)
            case .group: entityInstance = GroupStructure(dictionary: json)
            case .subject: entityInstance = SubjectStructure(dictionary: json)
            case .test: entityInstance = TestStructure(dictionary: json)
            case .testDetail: entityInstance = TestDetailStructure(dictionary: json)
            case .timeTable: entityInstance = TimeTableStructure(dictionary: json)
            case .question: entityInstance = QuestionStructure(dictionary: json)
            case .answer: entityInstance = AnswerStructure(dictionary: json)
            case .student: entityInstance = StudentStructure(dictionary: json)
            case .user: entityInstance = UserStructure(dictionary: json)
            case .result: entityInstance = TestResults(dictionary: json)
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
        guard let request = getURLReqest(entityStructure: forEntity, type: TypeReqest.getCount) else {
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
    
    func updateEntity<TypeEntity: Serializable>(byId: String, entity: TypeEntity, typeEntity: Entities,
                                                completionHandler: @escaping (_ error: String?) -> ()) {
        guard var request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.updateData, id: byId) else {
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
            }
            completionHandler(nil)
        }
    }
    func insertEntity<TypeEntity: Serializable>(entity: TypeEntity, typeEntity: Entities,
                                                completion: @escaping (_ confirmation: Any?, _ error: String?) -> ()) {
        guard var request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.insertData) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completion(nil, error)
            return }
        let postData = entity.dictionary
        do {
            let json = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = json
        } catch {
            completion(nil, error.localizedDescription)
        }
        getResponse(request: request) { (entity, error) in
            if let error = error {
                completion(nil, error)
            } else {
                guard let entity = entity else { return }
                switch typeEntity {
                case .student, .user:
                    guard let  json = entity as? [String: Any] else {
                        let errorMsg = NSLocalizedString("Response is empty: \(entity)",
                            comment: "No data in server response")
                        completion(nil, errorMsg)
                        return
                    }
                    // MARK: Debug part
                    completion(json["id"], nil)
                default:
                    guard let  json = entity as? [[String: Any]] else {
                        let errorMsg = NSLocalizedString("Response is empty: \(entity)",
                            comment: "No data in server response")
                        completion(nil, errorMsg)
                        return
                    }
                    completion(json, nil)
                }
            }
        }
    }
    
    func deleteEntity(byId: String, typeEntity: Entities,
                      completionHandler: @escaping (_ confirmation: Any?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: typeEntity, type: TypeReqest.delete, id: byId) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return
        }
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
    func getStudents(forGroup group: String, withoutImages: Bool,
                     completionHandler: @escaping (_ students: [StudentStructure]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: .student, type: TypeReqest.getStudentsByGroup,
                                         id: group, withoutImages: withoutImages) else {
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
    func getGroups(bySpeciality speciality: String,
                   completionHandler: @escaping (_ groups: [GroupStructure]?, _ error: String?) -> ()) {
        getList(byID: speciality, type: .getGroupBySpeciality, entityStructure: .group) {
            (list, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let list = list {
                let groupList = list as? [GroupStructure]
                completionHandler( groupList, nil)
            } else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
            }
        }
    }
    func getGroups(byFaculty faculty: String,
                   completionHandler: @escaping (_ groups: [GroupStructure]?, _ error: String?) -> ()) {
        getList(byID: faculty, type: .getGroupByFaculty, entityStructure: .group) {
            (list, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let list = list {
                let groupList = list as? [GroupStructure]
                completionHandler( groupList, nil)
            } else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
            }
        }
    }
    func getTestDetails(byTest test: String,
                        completionHandler: @escaping (_ testDetails: [TestDetailStructure]?, _ error: String?) -> ()) {
        getList(byID: test, type: .getTestDetailsByTest, entityStructure: .testDetail) {
            (list, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let list = list {
                let testList = list as? [TestDetailStructure]
                completionHandler( testList, nil)
            } else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
            }
        }
    }
    func getTest(bySubject subject: String,
                 completionHandler: @escaping (_ tests: [TestStructure]?, _ error: String?) -> ()) {
        getList(byID: subject, type: .getTestsBySubject, entityStructure: .test) {
            (list, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let list = list {
                let testList = list as? [TestStructure]
                completionHandler(testList, nil)
            } else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
            }
        }
    }
    func getTimeTables(forGroup group: String,
                       completionHandler: @escaping (_ tables: [TimeTableStructure]?, _ error: String?) -> ()) {
        getList(byID: group, type: .getTimeTablesForGroup, entityStructure: .timeTable) {
            (list, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let list = list {
                let timeTables = list as? [TimeTableStructure]
                completionHandler(timeTables, nil)
            } else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
            }
        }
    }
    func getTimeTables(forSubject subject: String,
                       completionHandler: @escaping (_ tables: [TimeTableStructure]?, _ error: String?) -> ()) {
        getList(byID: subject, type: .getTimeTablesForSubject, entityStructure: .timeTable) {
            (list, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let list = list {
                let timeTables = list as? [TimeTableStructure]
                completionHandler(timeTables, nil)
            } else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
            }
        }
    }
    
    private func getList(byID: String, type: TypeReqest, entityStructure: Entities,
                         completionHandler: @escaping (_ list: [Any]?, _ error: String?) -> ()) {
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
            case .testDetail: listAny = json.flatMap { TestDetailStructure(dictionary: $0) }
            case .group: listAny = json.flatMap { GroupStructure(dictionary: $0) }
            case .test: listAny = json.flatMap { TestStructure(dictionary: $0) }
            case .timeTable: listAny = json.flatMap { TimeTableStructure(dictionary: $0) }
            case .answer: listAny = json.flatMap { AnswerStructure(dictionary: $0) }
            default: completionHandler(nil, NSLocalizedString("Request not supported!",
                                                              comment: "Request not supported!"))
            }
            DispatchQueue.main.async {
                completionHandler(listAny, nil)
            }
        }
    }
    func getQuestionsRand(byLevel level: String, testID testId: String, number: String,
                          completionHandler: @escaping (_ questions: [QuestionStructure]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: .question,
                                         type: .getQuestionsByLevelRand, id: testId, limit: level,
                                         offset: number) else {
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
            let questionList = json.flatMap { QuestionStructure(dictionary: $0) }
            DispatchQueue.main.async {
                completionHandler(questionList, nil)
            }
        }
    }
    func getQuestionIdsRand(byLevel level: String, testID testId: String, number: String,
                            completionHandler: @escaping (_ questions: [String]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: .question, type: .getQuestionIdsByLevelRand, id: testId,
                                         limit: level, offset: number) else {
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
            guard let  json = list as? [[String: String]] else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
                return
            }
            let questionList = json.flatMap { $0["question_id"] }
            DispatchQueue.main.async {
                completionHandler(questionList, nil)
            }
        }
    }
    func getAnswers(byQuestion question: String,
                    completionHandler: @escaping (_ tables: [AnswerStructure]?, _ error: String?) -> ()) {
        getList(byID: question, type: .getAnswersByQuestion, entityStructure: .answer) {
            (list, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let list = list {
                let answerList = list as? [AnswerStructure]
                completionHandler(answerList, nil)
            } else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
            }
        }
    }
    func countRecords(byTest testId: String, completionHandler: @escaping (_ tables: UInt?, _ error: String?) -> ()) {
        
        guard let request = getURLReqest(entityStructure: .question, type: .countRecordsByTest, id: testId) else {
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
            guard let  json = list as? [String: String] else {
                let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                completionHandler(nil, error)
                return
            }
            guard let countString = json["numberOfRecords"] else { return }
            let result = UInt(countString)
            completionHandler(result, nil)
        }
    }
    func getRecordsRange(byTest testId: String, limit: String, offset: String,
                         completionHandler: @escaping (_ records: [QuestionStructure]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: .question, type: .getRecordsRangeByTest, id: testId,
                                         limit: limit, offset: offset) else {
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
            let recordList = json.flatMap { QuestionStructure(dictionary: $0) }
            completionHandler(recordList, nil)
        }
    }
    //Support Results entities
    func getResultsBy(groupId: String, testId: String,
                      completionHandler: @escaping (_ students: [TestResults]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: .result, type: .getRecordsByTestGroupDate, limit: testId, offset: groupId)
        else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                guard let  json = list as? [[String: Any]] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completionHandler(nil, error)
                    return
                }
                let testList = json.flatMap { TestResults(dictionary: $0) }
                completionHandler(testList, nil)
                return
            }
        }
    }
    func getTestsResultIds(byGroup id: String,
                           completionHandler: @escaping (_ testIds: [[String: String]]?, _ error: String?) -> ()) {
        guard let request = getURLReqest(entityStructure: .result, type: .getResultTestIdsByGroup, id: id)
            else {
                let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
                completionHandler(nil, error)
                return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                guard let  json = list as? [[String: String]] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completionHandler(nil, error)
                    return
                }
                completionHandler(json, nil)
            }
        }
    }
    //Support EntityManager from API
    func getTestsBy(ids: [String], completionHandler: @escaping (_ tests: [TestStructure]?, _ error: String?) -> ()) {
        guard let request = getURLReqestForEntityManager(entityStructure: .test, ids: ids) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                guard let  json = list as? [[String: Any]] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completionHandler(nil, error)
                    return
                }
                let tests = json.flatMap { TestStructure(dictionary: $0) }
                completionHandler(tests, nil)
            }
        }
    }
    func getSubjectsBy(ids: [String], completionHandler: @escaping (_ subjects: [SubjectStructure]?, _ error: String?) -> ()) {
        guard let request = getURLReqestForEntityManager(entityStructure: .subject, ids: ids) else {
            let error = NSLocalizedString("The Header isn't prepared!", comment: "Cannot prepare header for URLRequest")
            completionHandler(nil, error)
            return
        }
        getResponse(request: request) { (list, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                guard let  json = list as? [[String: Any]] else {
                    let error = NSLocalizedString("Response is empty", comment: "No data in server response")
                    completionHandler(nil, error)
                    return
                }
                let tests = json.flatMap { SubjectStructure(dictionary: $0) }
                completionHandler(tests, nil)
            }
        }
    }

    

}

