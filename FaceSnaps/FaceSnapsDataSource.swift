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
        }
    }
    
    var authToken: String? {
        get {
            guard let currentUser = currentUser else { return nil }
            return currentUser.authToken
        }
    }
    
    var latestFeed: Results<FeedItem> {
        get {
            return realm.objects(FeedItem.self)
        }
    }
    
    // This holds an array of post IDs for the current user's feed, from page 1 to infinity
    var postKeys: [Int]? {
        set {
            guard let newValue = newValue else { return }
            _ = FaceSnapsStrongbox.sharedInstance.archive(newValue, key: .postKeys)
        }
        get {
            return FaceSnapsStrongbox.sharedInstance.unarchive(objectForKey: .postKeys) as? [Int]
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
    
    // Background request for UIImage from URL String
    func photoFromURL(for feedItem: FeedItem, cache: Bool, completionHandler:
        @escaping (_ image: UIImage?) -> Void) {
        let photoURLString = feedItem.photoURLString
        let url = URL(string: photoURLString)!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data, let image = UIImage(data: data) else {
                    completionHandler(nil)
                    return
                }
                if cache {
                    let fileURL = try! self.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(feedItem.pk).jpg")
                    do {
                        try data.write(to: fileURL, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
                completionHandler(image)
            }

        }
        
        dataTask.resume()
    }

    func directoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
}
