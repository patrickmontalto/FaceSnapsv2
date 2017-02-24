//
//  ControlsCellDelegate.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/25/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

enum FeedItemButtonType {
    case like
    case comment
    case likesCount
    case authorName
}

protocol FeedItemSectionDelegate {
    func didPressLikeButton(forPost post: FeedItem, inSectionController sectionController: FeedItemSectionController, withButton button: UIButton)
    
    func didPressUserButton(forUser user: User)
    
    func didPressCommentButton(forPost post: FeedItem)
    
    func didPressLikesCount(forPost post: FeedItem)
}

extension FeedItemSectionDelegate where Self:UIViewController, Self:CommentDelegate, Self: FeedItemReloadDelegate {

    func didPressLikesCount(forPost post: FeedItem) {
        // .. Go to likes page for post
    }
    func didPressCommentButton(forPost post: FeedItem) {
        let vc = CommentController(post: post, delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPressUserButton(forUser user: User) {
        // .. Go to user profile
    }
    
    func didPressLikeButton(forPost post: FeedItem, inSectionController sectionController: FeedItemSectionController, withButton button: UIButton) {
        let action: FaceSnapsClient.LikeAction = post.liked ? .unlike : .like
        FaceSnapsClient.sharedInstance.likeOrUnlikePost(action: action, postId: post.pk) { (error) in
            if error == nil {
                post.liked = !post.liked
                guard let collectionContext = sectionController.collectionContext else { return }
                let likesViewCell = collectionContext.cellForItem(at: FeedItemSubsection.likes.rawValue, sectionController: sectionController) as! LikesViewCell
                if post.liked {
                    let image = UIImage(named: "ios-heart-red")!
                    button.setImage(image, for: .normal)
                    post.likesCount += 1
                } else {
                    let image = UIImage(named: "ios-heart-outline")!
                    button.setImage(image, for: .normal)
                    post.likesCount -= 1
                }
                
                likesViewCell.setLikesCount(count: post.likesCount)
            }
        }
    }
}
