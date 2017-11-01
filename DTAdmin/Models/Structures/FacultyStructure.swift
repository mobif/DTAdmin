//
//  FacultyStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
struct FacultyStructure: Serializable {
    var id: String?
    var name: String
    var description: String?
    init?(dictionary: [String: Any]) {
        id = dictionary["faculty_id"] as? String
        description = dictionary["faculty_description"] as? String
        guard let name = dictionary["faculty_name"] as? String else { return nil }
        self.name = name
    }
    var dictionary: [String: Any] {
        var result:[String: Any] = ["faculty_name": self.name]
        if let id = self.id { result["faculty_id"] = id }
        if let description = self.description { result["faculty_description"] = description }
        return result
    }
}
