//
//  Comment.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

class Comment {
    
    let author: User
    let text: String
    
    init(author: User, text: String) {
        self.author = author
        self.text = text
    }
}
