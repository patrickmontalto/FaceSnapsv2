//
//  User.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import IGListKit
import RealmSwift

class User: Object, IGListDiffable {
    
    // MARK: - Properties
    dynamic var pk: Int = 0
    dynamic var name: String = ""
    dynamic var email: String = ""
    dynamic var userName: String = ""
    dynamic var photoData: Data = Data()
    dynamic var authToken: String = ""
    dynamic var outgoingStatus: String = ""
    dynamic var incomingStatus: String = ""
    dynamic var postsCount: Int = 0
    dynamic var followersCount: Int = 0
    dynamic var followingCount: Int = 0
    dynamic var privateProfile: Bool = false

    /// A boolean represent whether or not the current user is following this user
    var isFollowing: Bool {
        get {
            guard let status = FollowResult(rawValue: self.incomingStatus), status == .follows else {
                return false
            }
            return true
        } set {
            self.incomingStatus = newValue ? FollowResult.follows.rawValue : FollowResult.none.rawValue
        }
    }
    
    /// A boolean representing whether or not the current user is the user in question
    var isCurrentUser: Bool {
        return FaceSnapsDataSource.sharedInstance.currentUser!.pk == self.pk
    }
    
    
    // MARK: - Initializers
    convenience init(pk: Int, name: String, email: String, userName: String, photoURLString: String?, authToken: String, postsCount: Int, followersCount: Int, followingCount: Int, privateProfile: Bool, outgoingStatus: String, incomingStatus: String) {
        self.init()
        
        self.pk = pk
        self.name = name
        self.email = email
        self.userName = userName
        self.authToken = authToken
        self.postsCount = postsCount
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.privateProfile = privateProfile
        self.incomingStatus = incomingStatus
        self.outgoingStatus = outgoingStatus
        
        guard let photoURLString = photoURLString, let photoURL = URL(string: photoURLString) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: photoURL)
            self.photoData = data
        } catch {}
    }
    
    var photo: UIImage? {
        get {
            return UIImage(data: self.photoData)
        }
    }
    /// Accepts a JSON dictionary representing a user object.
    /// 
    /// Will Update email, name, username, and photo.
    ///
    /// - parameter userDictionary: The JSON representation of the user object.
    func update(userDictionary: [String: Any]) {
        let email = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.email] as! String
        let name = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.fullName] as! String
        let username = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.username] as! String
//        let private = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.privateProfile]
        if let photoPath = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.photoPath] as? String {
            let photoURLstring = FaceSnapsClient.urlString(forPhotoPath: photoPath)
            if let photoURL = URL(string: photoURLstring) {
                do {
                    let data = try Data(contentsOf: photoURL)
                    self.photoData = data
                } catch {}
            }
        }
        
        self.email = email
        self.name = name
        self.userName = username
        // self.private = private
        
        if let followersCount = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.followersCount] as? Int {
            self.followersCount = followersCount
        }
        
        if let followingCount = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.followingCount] as? Int {
            self.followingCount = followingCount
        }
        
    }
    
    // MARK: - IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return pk as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? User else { return false }
        return name == object.name && userName == object.userName
    }
}
