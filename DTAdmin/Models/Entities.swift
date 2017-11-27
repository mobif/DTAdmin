//
//  Entities.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

enum Entities: String {
    case faculty = "Faculty"
    case speciality = "Speciality"
    case group = "Group"
    case subject = "Subject"
    case test = "Test"
    case testDetail = "TestDetail"
    case timeTable = "TimeTable"
    case question = "Question"
    case answer = "Answer"
    case student = "Student"
    case user = "AdminUser"
    case result = "Result"
    static let allValues: [Entities] = [faculty, speciality, group, subject, test, testDetail, timeTable, question,
                                        answer, student, user, result]
}

