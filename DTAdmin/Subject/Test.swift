//
//  Test.swift
//  DTAdmin
//
//  Created by ITA student on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.


// Test: {test_id, test_name, subject_id, tasks, time_for_test, enabled, attempts}

import Foundation

struct Test {
    let testId: String
    let testName: String
    let subjectId: String
    let tasks: String
    let timeForTest: String
    let enabled: String
    let attempts: String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(testId: String, testName: String, subjectId: String, tasks: String, timeForTest: String, enabled: String, attempts: String) {
//        guard let testId = json["test_id"] as? String else {throw SerializationError.missing("summary is missing")}
//        guard let testName = json["test_name"] as? String else {throw SerializationError.missing("icon is missing")}
//        guard let subjectId = json["subject_id"] as? String else {throw SerializationError.missing("temp is missing")}
//        guard let tasks = json["tasks"] as? String else {throw SerializationError.missing("summary is missing")}
//        guard let timeForTest = json["time_for_test"] as? String else {throw SerializationError.missing("icon is missing")}
//        guard let enabled = json["enabled"] as? String else {throw SerializationError.missing("temp is missing")}
//        guard let attempts = json["attempts"] as? String else {throw SerializationError.missing("temp is missing")}
        
        self.testId = testId
        self.testName = testName
        self.subjectId = subjectId
        self.tasks = tasks
        self.timeForTest = timeForTest
        self.enabled = enabled
        self.attempts = attempts
    }
    
    static let basePath = "http://vps9615.hyperhost.name/test/getTestsBySubject/"
    
    static func showTests (sufix: String, completion: @escaping ([Test]?) -> ()) {
        
        guard let url = URL(string: basePath + sufix) else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var testrecords: [Test] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        for trackDictionary in json {
                            if let trackDictionary = trackDictionary as? [String: Any],
                                let testId = trackDictionary["test_id"] as? String ,
                                let testName = trackDictionary["test_name"] as? String,
                                let subjectId = trackDictionary["subject_id"] as? String,
                                let tasks = trackDictionary["tasks"] as? String ,
                                let timeForTest = trackDictionary["time_for_test"] as? String,
                                let enabled = trackDictionary["enabled"] as? String,
                                let attempts = trackDictionary["attempts"] as? String {
                                testrecords.append(Test(testId: testId, testName: testName, subjectId: subjectId, tasks: tasks, timeForTest: timeForTest, enabled: enabled, attempts: attempts))
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(testrecords)
                
            }
            
            
        }
        
        task.resume()
    }
}

    
    

    

