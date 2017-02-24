//
//  CommentDelegate.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

// Responsible for handling user initiated taps on author or reply buttons
protocol CommentDelegate {
    func didTapAuthor(author: User)
    func didTapReply(toAuthor author: User)
}

extension CommentDelegate {
    func didTapAuthor(author: User) {
        // Go to user profile
    }
    
    func didTapReply(toAuthor author: User) {}
}
