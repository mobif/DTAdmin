//
//  TimeTableStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/25/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
struct TimeTableStructure {
    var id: String?
    var groupId: String
    var subjectId: String
    var startDate: String
    var startTime: String
    var endDate: String
    var endTime: String
    init?(dictionary: [String: Any]) {
        id = dictionary["timetable_id"] as? String
        guard let groupId = dictionary["group_id"] as? String,
            let subjectId = dictionary["subject_id"] as? String,
            let startDate = dictionary["start_date"] as? String,
            let startTime = dictionary["start_time"] as? String,
            let endDate = dictionary["end_date"] as? String,
            let endTime = dictionary["end_time"] as? String
            else { return nil }
        self.groupId = groupId
        self.subjectId = subjectId
        self.startDate = startDate
        self.startTime = startTime
        self.endDate = endDate
        self.endTime = endTime
    }
}
