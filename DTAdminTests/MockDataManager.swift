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
        
        
    }
    func getUploadedFileSet(fileName: String) -> Data {
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        print(dir)
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("test") {
            do {
                let data = try Data(contentsOf: fileURL, options: [])
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                //print(jsonResult)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
//                    let firstElemenet = jsonResult["role1"] as? [Any] {
//                    print(firstElemenet)
//                    self.selectKeyButton.isEnabled = true
//                    collectionTests = jsonResult
//                    let strData = String(describing: jsonResult)
//                    fileContentTextView.text = strData
                    let resultData = jsonResult[urlRequest] as? Data
                    return resultData
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
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
