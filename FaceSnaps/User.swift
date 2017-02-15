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
    
    dynamic var pk: Int = 0
    dynamic var name: String = ""
    dynamic var userName: String = ""
    dynamic var photoData: Data = Data()
    dynamic var authToken: String = ""
    dynamic var isFollowing: Bool = false
    // TODO: Posts property?
    
    convenience init(pk: Int, name: String, userName: String, photoURLString: String?, authToken: String, isFollowing: Bool) {
        self.init()
        
        self.pk = pk
        self.name = name
        self.userName = userName
        self.authToken = authToken
        self.isFollowing = isFollowing
        
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
