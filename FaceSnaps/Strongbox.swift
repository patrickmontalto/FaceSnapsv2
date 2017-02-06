//
//  Strongbox.swift
//  FaceSnaps
//
//  Created by Patrick on 1/5/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import Security
import Strongbox

class FaceSnapsStrongbox {
    static let sharedInstance = FaceSnapsStrongbox()
    
    private let strongBox = Strongbox()
    
    private init() {}
    
    func archive(_ object: Any?, key: Constant.Key) -> Bool {
        let keyString = key.rawValue
        return strongBox.archive(object, key: keyString)
    }
    
    func unarchive(objectForKey key: Constant.Key) -> Any? {
        let keyString = key.rawValue
        return strongBox.unarchive(objectForKey: keyString)
    }
    
    // MARK: - Constants for Strongbox
    enum Constant {
        enum Key:String {
            case postKeys, lastFeedJSON
        }
    }
}

