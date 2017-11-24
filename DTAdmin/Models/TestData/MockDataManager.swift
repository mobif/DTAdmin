//
//  MockDataManager.swift
//  DTAdmin
//
//  Created by Володимир on 19.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class MockDataManager: HTTPManager, DataRequestable {
    static let shared = MockDataManager()
    var data: Data?
    var response: Any?
    var error: Error?
    private override init(){}
    var urlRequest: String = ""
    func setError(_ domain: String, _ code: HTTPStatusCodes) {
        self.error = NSError(domain: domain, code: code.rawValue, userInfo: nil)
    }
    func setData(caseURL: String) {
        loadJSON() {
            (json, error) in
            if let json = json {
                if let response = json[caseURL] {
                    self.data = try? JSONSerialization.data(withJSONObject: response,
                                                            options: JSONSerialization.WritingOptions.prettyPrinted)
                }
            }
        }
        
    }
    func loadJSON(finishedClosure:@escaping ((_ jsonObject:[String:AnyObject]?,_ error: NSError?) ->Void)) {
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: "test_cases", ofType: "json") else{
                DispatchQueue.main.async {
                    finishedClosure(nil, NSError(domain: "JSON file don't founded", code: 998, userInfo: nil))
                }
                return
            }
            //Load file data part
            guard let jsonData = (try? Data(contentsOf: URL(fileURLWithPath: path))) else{
                DispatchQueue.main.async {
                    finishedClosure(nil, NSError(domain: "can convert to data", code: 999, userInfo: nil))
                }
                return
            }
            print(jsonData)
            do {
                //JSONSerialization.ReadingOptions.mutableContainers replaced by []
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if    let jsonResponse = jsonObject as? [String:AnyObject]
                {
                    DispatchQueue.main.async {
                        finishedClosure(jsonResponse,nil)
                    }
                }
            } catch let error as NSError {
                print(error)
                DispatchQueue.main.async {
                    finishedClosure(nil,error)
                }
            }
        }
    }
    
    func getResponse(request: URLRequest, completionHandler: @escaping (_ list: Any?, _ error: String?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            [unowned self] in
            if let sessionError = self.error {
                DispatchQueue.main.async {
                    completionHandler(nil, sessionError.localizedDescription)
                }
            } else {
                guard let responseValue = self.response as? HTTPURLResponse else {
                    let errorMsg = NSLocalizedString("Incorect server response!", comment: "Incorect server response!")
                    DispatchQueue.main.async {
                        completionHandler(nil, errorMsg)
                    }
                    return
                }
                guard let sessionData = self.data else {
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
                        errorMsg = NSLocalizedString("Error response: \(responseValue.statusCode) - \(errorMsg)",
                                                        comment: "Incorrect request")
                        completionHandler(nil, errorMsg)
                    }
                }
            }
        }
    }
}
