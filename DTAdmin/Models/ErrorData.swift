//
//  ErrorData.swift
//  DTAdmin
//
//  Created by Володимир on 26.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
class ErrorData {
    var message: String
    var code: Int?
    var descriptionError: String?
    var nserror: NSError?
    init(_ message: String) {
        self.message = message
    }
}
