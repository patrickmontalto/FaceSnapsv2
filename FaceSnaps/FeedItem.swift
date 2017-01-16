//
//  FeedItem.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import IGListKit

final class FeedItem: IGListDiffable {
    
    let pk: Int
    let user: User
    let comments: [Comment]
    let photo: UIImage
    
    init(pk: Int, user: User, comments: [Comment], photoURLString: String) {
        self.pk = pk
        self.user = user
        self.comments = comments
        
        guard let photoURL = URL(string: photoURLString) else {
            self.photo = UIImage()
            return
        }
        
        do {
            let data = try Data(contentsOf: photoURL)
            self.photo = UIImage(data: data)!
        } catch {
            self.photo = UIImage()
        }
    }
    
    // MARK: - IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return pk as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? FeedItem else { return false }
        return user.isEqual(toDiffableObject: object.user) //&& comments == object.comments
    }
    
}
