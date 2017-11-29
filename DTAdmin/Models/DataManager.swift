//
//  DataManager.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/24/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class DataManager: HTTPManager, DataRequestable {
    
    static let shared = DataManager()
    private var session:URLSession = URLSession.shared
    private override init(){}

    func getResponse(request: URLRequest, completionHandler: @escaping (_ list: Any?, _ error: ErrorData?) -> ()) {
        session.dataTask(with: request) { (data, response, error) in
            if let sessionError = error {
                DispatchQueue.main.async {
                    let errorMsg = sessionError.localizedDescription
                    let errorData = ErrorData(errorMsg, ErrorType.error)
                    errorData.nserror = sessionError as NSError
                    completionHandler(nil, errorData)
                }
            } else {
                guard let responseValue = response as? HTTPURLResponse else {
                    let errorMsg = NSLocalizedString("Incorect server response!", comment: "Incorect server response!")
                    DispatchQueue.main.async {
                        completionHandler(nil, ErrorData(errorMsg, ErrorType.error))
                    }
                    return
                }
                guard let sessionData = data else {
                    let errorMsg = NSLocalizedString("Response is empty", comment: "No data in server response")
                    let error = ErrorData(errorMsg, ErrorType.warning)
                    error.code = HTTPStatusCodes.NotFound.rawValue
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
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
                        if let errorReason = json as? [String: String]  {
                            guard let errorServerMsg = errorReason["response"] else { return }
                            errorMsgResponse = errorServerMsg
                        }
                        let errorMsg = NSLocalizedString("Error response", comment: "Incorrect request")
                        let errorData = ErrorData(errorMsg, ErrorType.error)
                        errorData.code = responseValue.statusCode
                        errorData.descriptionError = errorMsgResponse
                        completionHandler(nil, errorData)
                    }
                }
            }
        }.resume()
    }
}


