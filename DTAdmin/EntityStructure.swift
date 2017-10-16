//
//  EntityStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

//import Foundation

protocol EntityStructure {
    
    associatedtype Entity
    
    func getEntity()-> Entity.Type
}
