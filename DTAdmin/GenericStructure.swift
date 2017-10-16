//
//  GenericStructure.swift
//  DTAdmin
//
//  Created by Володимир on 10/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import Foundation

class GenericStructure<P>: EntityStructure {
    typealias Entity = P
    
    private let entity: P
    
    init(_ entity: P) {
        self.entity = entity
    }
    
    func getEntity() -> GenericStructure<P>.Entity.Type {
        return P.self
    }
    
}
