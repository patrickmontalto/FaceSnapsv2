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
    func didTapMention(username: String)
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
        let tag = Tag(id: 0, name: tag, postsCount: 0)
        let vc = TagPostsController(tag: tag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapMention(username: String) {
        FaceSnapsClient.sharedInstance.searchUsers(queryString: username, completionHandler: { (users, error) in
            guard let users = users, let user = users.first,
                user.userName.lowercased() == username.lowercased() else {
                // Unable to find user
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                self.displayAlert(withMessage: "Unable to find user.", title: "Error", actions: [action])
                return
            }
            
            let vc = ProfileController()
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        })
    }
}
