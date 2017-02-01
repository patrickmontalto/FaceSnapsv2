//
//  FaceSnapsDataSource.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class FaceSnapsDataSource {
    
    let fileManager = FileManager.default
    
    // MARK: Properties
    let realm = try! Realm()
    
    var currentUser: User? {
        get {
            return realm.objects(User.self).first
            // return FaceSnapsStrongbox.sharedInstance.unarchive(objectForKey: .currentUser) as? User
        }
    }
    
    var authToken: String? {
        get {
            guard let currentUser = currentUser else { return nil }
            return currentUser.authToken
        }
    }
    
    var latestFeed: Results<FeedItem>? {
        get {
            return realm.objects(FeedItem.self)
        }
    }
    
    var signedIn: Bool {
        return !(currentUser == nil)
    }
    
    // Shared model
    
    private init() {}
    
    // MARK: - Singleton
    static let sharedInstance: FaceSnapsDataSource = FaceSnapsDataSource()
    
    func setCurrentUser(asUser user: User) -> Bool {
        // Wipe database when setting current user
        wipeRealm()
        
        do {
            try realm.write({
                realm.add(user)
            })
            return true
        } catch {
            return false
        }
//        return FaceSnapsStrongbox.sharedInstance.archive(user, key: .currentUser)
    }
    
    // TODO: Can we just write an entire array?
    func setLatestFeed(asFeed feed: List<FeedItem>) -> Bool {
        deleteFeedItems()
        
        do {
            try realm.write({
                realm.add(feed)
            })
            return true
        } catch {
            return false
        }
//        return FaceSnapsStrongbox.sharedInstance.archive(feed, key: .latestFeed)
    }
    
    func wipeRealm() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteFeedItems() {
        try! realm.write {
            realm.delete(realm.objects(FeedItem.self))
        }
    }

    func directoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
}
