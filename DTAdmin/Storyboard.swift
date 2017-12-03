//
//  Storyboard.swift
//  DTAdmin
//
//  Created by mac6 on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func stoyboard(by type: StoryboardType) -> UIStoryboard {
        return UIStoryboard.init(name: type.rawValue, bundle: nil)
    }
}

enum StoryboardType: String {
    case subject = "Subjects"
    case timeTable = "TimeTable"
    case admin = "Admin"
    case group = "Group"
    case student = "Student"
    case test = "Test"
    case speciality = "Speciality"
    case testDetails = "TestDetails"
    case faculty = "Faculty"
}
