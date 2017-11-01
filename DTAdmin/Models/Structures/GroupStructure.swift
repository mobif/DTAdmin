//
//  GroupStructure.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct GroupStructure: Serializable {
    var groupId: String?
    var groupName: String
    var specialityId: String
    var facultyId: String
    init?(dictionary: [String: Any]) {
        groupId = dictionary["group_id"] as? String
        guard let groupName = dictionary["group_name"] as? String,
            let specialityId = dictionary["speciality_id"] as? String,
            let facultyId = dictionary["faculty_id"] as? String else { return nil }
        self.groupName = groupName
        self.specialityId = specialityId
        self.facultyId = facultyId
    }
    var dictionary: [String: Any] {
        var result:[String: Any] = ["group_name": self.groupName, "speciality_id": self.specialityId, "faculty_id": self.facultyId]
        if let groupId = self.groupId { result["group_id"] = groupId }
        return result
    }
}
