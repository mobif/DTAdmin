//
//  SubjectStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
struct SubjectStructure: Serializable {
    var id: String?
    var name: String
    var description: String?
    init?(dictionary: [String: Any]) {
        id = dictionary["subject_id"] as? String
        description = dictionary["subject_description"] as? String
        guard let name = dictionary["subject_name"] as? String else { return nil }
        self.name = name
    }
    var dictionary: [String: Any] {
        var result: [String: Any] = ["subject_name": self.name]
        if let id = self.id { result["subject_id"] = id }
        if let description = self.description { result["subject_description"] = description }
        return result
    }
}
