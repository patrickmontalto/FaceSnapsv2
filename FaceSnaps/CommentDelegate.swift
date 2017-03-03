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
    func didTapHashtag(tag: String)
}

extension CommentDelegate where Self:UIViewController {
    func didTapAuthor(author: User) {
        // Go to user profile
        let vc = ProfileController()
        vc.user = author
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapReply(toAuthor author: User) {
        // TODO: Fill out @author inside of comment textfield
    }
    
    func didTapHashtag(tag: String) {
        // TODO: Present FeedItemThumbnailSectionController with hashtag as title.
        // Make new API endpoint for this in client.
    }
}
