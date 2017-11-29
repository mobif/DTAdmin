//
//  ErrorData.swift
//  DTAdmin
//
//  Created by Володимир on 26.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

enum ErrorType: String {
    case alert = "Alert!"
    case warning = "Warning!"
    case error = "Error!!!"
}
class ErrorData {
    var message: String
    var code: Int?
    var descriptionError: String?
    var nserror: NSError?
    var type: ErrorType
    init(_ message: String, _ type: ErrorType) {
        self.message = message
        self.type = type
    }
    var info: String {
        let code = self.code != nil ? String(describing: self.code) : ""
        let description = self.descriptionError ?? ""
        return self.type.rawValue + message + " \(code): \(description)"
    }
}
