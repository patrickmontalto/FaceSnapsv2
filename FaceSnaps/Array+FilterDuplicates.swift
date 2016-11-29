//
//  Array+FilterDuplicates.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/24/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation

extension Array {
    
    func filterDuplicates(includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}















