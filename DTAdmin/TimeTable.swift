//
//  TimeTable.swift
//  DTAdmin
//
//  Created by mac6 on 10/22/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

struct TimeTable {
    var timetableID: String?
    var groupID: String?
    var subjectID: String?
    var startDate: String?
    var startTime: String?
    var endDate: String?
    var endTime: String?
    
    init() {}
    
    init(json: [String: Any]?) {
        if let timeTableID = json?["timetable_id"] as? String {
            self.timetableID = timeTableID
        }
        if let groupID = json?["group_id"] as? String {
            self.groupID = groupID
        }
        if let subjectID = json?["subject_id"] as? String {
            self.subjectID = subjectID
        }
        if let startDate = json?["start_date"] as? String {
            self.startDate = startDate
        }
        if let startTime = json?["end_time"] as? String {
            self.startTime = startTime
        }
        if let endDate = json?["end_date"] as? String {
            self.endDate = endDate
        }
        if let endTime = json?["end_time"] as? String {
            self.endTime = endTime
        }
    }
    
    var jsonRepresentation: [String: String] {
        var dict = [String: String] ()
        dict["group_id"] = groupID ?? ""
        dict["subject_id"] = subjectID ?? ""
        dict["start_date"] = startDate ?? ""
        dict["start_time"] = startTime ?? ""
        dict["end_date"] = endDate ?? ""
        dict["end_time"] = endTime ?? ""
        return dict
    }
}
