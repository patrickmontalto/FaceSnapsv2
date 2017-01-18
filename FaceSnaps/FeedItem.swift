//
//  FeedItem.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import IGListKit
import RealmSwift

final class FeedItem: Object, IGListDiffable {
    
    dynamic var pk: Int = 0
    dynamic var user: User?
    dynamic var caption: String = ""
    var comments = List<Comment>()
    dynamic var photoData: Data = Data()
    
    convenience init(pk: Int, user: User, caption: String, comments: List<Comment>, photoURLString: String) {
        self.init()
        
        self.pk = pk
        self.user = user
        self.caption = caption
        self.comments = comments
        
        guard let photoURL = URL(string: photoURLString) else {
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
        guard let object = object as? FeedItem else { return false }
        return user!.isEqual(toDiffableObject: object.user) //&& comments == object.comments
    }
    
}
