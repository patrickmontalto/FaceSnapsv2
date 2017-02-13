//
//  Comment.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import RealmSwift
import IGListKit


class Comment: Object, IGListDiffable {
    
    dynamic var pk: Int = 0
    dynamic var author: User?
    dynamic var text: String = ""
    dynamic var datePosted: Date = Date()
    // TODO: Inverse relationship for post
    // TODO: Inverse relationship for author?
    
    convenience init(pk: Int, author: User, text: String, datePosted: Date) {
        self.init()
        
        self.pk = pk
        self.author = author
        self.text = text
        self.datePosted = datePosted
    }
    
    // MARK: - IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return pk as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Comment else { return false }
        return author!.isEqual(toDiffableObject: object.author)
    }
    
    
}
