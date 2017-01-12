//
//  FaceSnapsDataSource.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

class FaceSnapsDataSource {
    
    // MARK: Properties
    var authToken: String? {
        get {
            return FaceSnapsStrongbox.sharedInstance.unarchive(objectForKey: .authToken) as? String
        }
    }
    
    // Shared model
    
    private init() {}
    
    // MARK: - Singleton
    static let sharedInstance: FaceSnapsDataSource = FaceSnapsDataSource()
    
    
}
