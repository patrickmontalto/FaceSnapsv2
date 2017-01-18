//
//  Comment.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import RealmSwift

class Comment: Object {
    
    dynamic var pk: Int = 0
    dynamic var author: User?
    dynamic var text: String = ""
    // TODO: Inverse relationship for post
    // TODO: Inverse relationship for author?
    
    convenience init(pk: Int, author: User, text: String) {
        self.init()
        
        self.pk = pk
        self.author = author
        self.text = text
    }
}
