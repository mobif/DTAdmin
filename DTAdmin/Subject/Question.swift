//
//  Question.swift
//  DTAdmin
//
//  Created by ITA student on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//
// Question: {question_id, test_id, question_text, level, type, attachment}

import Foundation

struct Question {
    let questionId: String
    let testId: String
    let questionText: String
    let level: String
    let type: String
    let attachment: String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(questionId: String, testId: String, questionText: String, level: String, type: String, attachment: String) {
        self.questionId = questionId
        self.testId = testId
        self.questionText = questionText
        self.level = level
        self.type = type
        self.attachment = attachment
    }
    
    static let basePath = "http://vps9615.hyperhost.name/question/"
    
    static func showQuestions (sufix: String, completion: @escaping ([Question]?) -> ()) {
        
        guard let url = URL(string: basePath + sufix) else { return }
        print(url)
        let request = URLRequest(url: url)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var questionRecords: [Question] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        for trackDictionary in json {
                            if let trackDictionary = trackDictionary as? [String: Any],
                                let questionId = trackDictionary["question_id"] as? String ,
                                let testId = trackDictionary["test_id"] as? String,
                                let questionText = trackDictionary["question_text"] as? String,
                                let level = trackDictionary["level"] as? String ,
                                let type = trackDictionary["type"] as? String,
                                let attachment = trackDictionary["attachment"] as? String {
                                questionRecords.append(Question(questionId: questionId, testId: testId, questionText: questionText, level: level, type: type, attachment: attachment))
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(questionRecords)
                
            }
            
            
        }
        
        task.resume()
    }
    
    static func postRequests(parameters: [String : String], sufix: String, completion: @escaping ([Question]?, Int) -> ()) {
        
        guard let url = URL(string: basePath + sufix) else { return }
        print(url)
        var request = URLRequest(url: url)
        print(request)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            var questionRecords = [Question]()
            let response = response as? HTTPURLResponse
            if let response = response {
                print(response)
            }
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        print(json)
                        for trackDictionary in json {
                            if let trackDictionary = trackDictionary as? [String: Any],
                                let questionId = trackDictionary["question_id"] as? String ,
                                let testId = trackDictionary["test_id"] as? String,
                                let questionText = trackDictionary["question_text"] as? String,
                                let level = trackDictionary["level"] as? String ,
                                let type = trackDictionary["type"] as? String,
                                let attachment = trackDictionary["attachment"] as? String {
                                questionRecords.append(Question(questionId: questionId, testId: testId, questionText: questionText, level: level, type: type, attachment: attachment))
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(questionRecords, response!.statusCode)
                
            }
            
        }
        task.resume()
        
    }

}
