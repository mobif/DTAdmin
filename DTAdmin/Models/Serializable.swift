//
//  Serializable.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

protocol Serializable {
    var dictionary: [String: Any] {
        get
    }
}
