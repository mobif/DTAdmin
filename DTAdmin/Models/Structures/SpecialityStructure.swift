//
//  SpecialityStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
class SpecialityStructure: Serializable {
    var id: String?
    var name: String
    var code: String
    init?(dictionary: [String: Any]) {
        id = dictionary["speciality_id"] as? String
        guard let name = dictionary["speciality_name"] as? String, let code = dictionary["speciality_code"] as? String else { return nil }
        self.name = name
        self.code = code
    }
    var dictionary: [String: Any] {
        var result:[String: Any] = ["speciality_name": self.name, "speciality_code": self.code]
        if let id = self.id { result["speciality_id"] = id }
        return result
    }
}

