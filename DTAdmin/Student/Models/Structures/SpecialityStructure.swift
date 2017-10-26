//
//  SpecialityStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
class SpecialityStructure {
    var id: String?
    var name: String
    var code: String?
    init?(dictionary: [String: Any]) {
        id = dictionary["speciality_id"] as? String
        code = dictionary["speciality_code"] as? String
        guard let name = dictionary["speciality_name"] as? String else { return nil }
        self.name = name
    }
}

