//
//  MockDataManager.swift
//  DTAdmin
//
//  Created by Volodymyr on 19.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class MockDataManager: HTTPManager, DataRequestable {
    static let shared = MockDataManager()
    var path: String?
    var data: Data?
    var response: HTTPURLResponse?
    var error: ErrorData?
    private override init(){}
    var urlRequest: String = ""
    func setPath(_ path: String) {
        self.path = path
    }
    func prepareDataForTest(caseURL: String) {
        if let json = loadJSON(),
            let responseCase = json[caseURL],
            let responseData = responseCase as? [String: AnyObject],
            let data = responseData["data"],
            let response = responseData["response"] as? String,
            let url = URL(string: caseURL),
            let statusCode = Int(response) {
                self.data = try? getData(json: data)
                self.response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        }
    }
    func loadJSON() -> [String: AnyObject]? {
        guard let path = self.path,
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let jsonObject = try? getJSON(data: jsonData),
            let jsonResponse = jsonObject as? [String: AnyObject]
            else { return nil }
        return jsonResponse
    }
    
    func getResponse(request: URLRequest, completionHandler: @escaping (_ list: Any?, _ error: ErrorData?) -> ()) {
        DispatchQueue.global().async {
            [unowned self] in
            guard let urlRequest = request.url?.absoluteString else {
                DispatchQueue.main.async {
                    let errorMsg = NSLocalizedString("Request incorrect", comment: "Request incorrect!")
                    completionHandler(nil, ErrorData(errorMsg, ErrorType.error))
                }
                return
            }
            
            self.prepareDataForTest(caseURL: urlRequest)
            if let sessionError = self.error {
                DispatchQueue.main.async {
                    completionHandler(nil, sessionError)
                }
            } else {
                guard let responseValue = self.response else {
                    let errorMsg = NSLocalizedString("Incorect server response!", comment: "Incorect server response!")
                    DispatchQueue.main.async {
                        completionHandler(nil, ErrorData(errorMsg, ErrorType.error))
                    }
                    return
                }
                guard let sessionData = self.data else {
                    let errorMsg = NSLocalizedString("Response is empty", comment: "No data in server response")
                    DispatchQueue.main.async {
                        completionHandler(nil, ErrorData(errorMsg, ErrorType.warning))
                    }
                    return
                }
                //JSON Serialization
                var json: Any
                do {
                    json = try self.getJSON(data: sessionData)
                } catch {
                    DispatchQueue.main.async {
                        let errorMsg = error.localizedDescription
                        let errorData = ErrorData(errorMsg, ErrorType.error)
                        errorData.nserror = error as NSError
                        completionHandler(nil, errorData)
                    }
                    return
                }
                DispatchQueue.main.async {
                    if responseValue.statusCode == HTTPStatusCodes.OK.rawValue {
                        completionHandler(json, nil)
                    } else {
                        var errorMsgResponse: String = ""
                        var errorType = ErrorType.warning
                        if let errorReason = json as? [String: String]  {
                            guard let errorServerMsg = errorReason["response"] else { return }
                            errorMsgResponse = errorServerMsg
                            errorType = ErrorType.error
                        }
                        let errorMsg = NSLocalizedString("Error response", comment: "Incorrect request")
                        let errorData = ErrorData(errorMsg, errorType)
                        errorData.code = responseValue.statusCode
                        errorData.descriptionError = errorMsgResponse
                        completionHandler(nil, errorData)
                    }
                }
            }
        }
    }
}
