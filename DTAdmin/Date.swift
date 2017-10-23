//
//  Date.swift
//  DTAdmin
//
//  Created by mac6 on 10/23/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter.string(from: self)
    }
}
