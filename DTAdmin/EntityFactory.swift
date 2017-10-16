//
//  EntityFactory.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation
class EntityFactory{
    static func getEntity(byType: ) -> Decodable {
        switch byStructure {
        case .Student:
            return Student()
        case .User:
            return User()
        
        }
    }
}
