//
//  Array+RemoveObjectsInArray.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/31/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func removingObject(object: Element) -> [Element] {
        var newArray = self
        
        if let index = newArray.index(of: object) {
            newArray.remove(at: index)
        }
        
        return newArray
    }
    
    mutating func removingObjectsInArray(array: [Element]) -> [Element] {
        var newArray = self
        
        for object in array {
            newArray = newArray.removingObject(object: object)
        }
        
        return newArray
    }
}
