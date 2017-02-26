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
    dynamic var isFollowing: Bool = false
    dynamic var postsCount: Int = 0
    dynamic var followersCount: Int = 0
    dynamic var followingCount: Int = 0
    dynamic var privateProfile: Bool = false
    // TODO: Posts property?
    
    // MARK: - Initializers
    convenience init(pk: Int, name: String, email: String, userName: String, photoURLString: String?, authToken: String, isFollowing: Bool, postsCount: Int, followersCount: Int, followingCount: Int, privateProfile: Bool) {
        self.init()
        
        self.pk = pk
        self.name = name
        self.email = email
        self.userName = userName
        self.authToken = authToken
        self.isFollowing = isFollowing
        self.postsCount = postsCount
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.privateProfile = privateProfile
        
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
//        let private = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.]
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
