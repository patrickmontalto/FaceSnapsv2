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
    
    var currentUser: User? {
        get {
            return FaceSnapsStrongbox.sharedInstance.unarchive(objectForKey: .currentUser) as? User
        }
    }
    
    var authToken: String? {
        get {
            guard let currentUser = currentUser else { return nil }
            return currentUser.authToken
        }
    }
    
    var latestFeed: [FeedItem]? {
        get {
            return FaceSnapsStrongbox.sharedInstance.unarchive(objectForKey: .latestFeed) as? [FeedItem]
        }
    }
    
    // Shared model
    
    private init() {}
    
    // MARK: - Singleton
    static let sharedInstance: FaceSnapsDataSource = FaceSnapsDataSource()
    
    func setCurrentUser(asUser user: User) -> Bool {
        return FaceSnapsStrongbox.sharedInstance.archive(user, key: .currentUser)
    }
    
    func setLatestFeed(asFeed feed: [FeedItem]) -> Bool {
        return FaceSnapsStrongbox.sharedInstance.archive(feed, key: .latestFeed)
    }
    
}
