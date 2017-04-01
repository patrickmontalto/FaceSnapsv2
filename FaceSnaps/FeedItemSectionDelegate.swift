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
    
    func didPressLocationButton(location: Location)
}

extension FeedItemSectionDelegate where Self:UIViewController, Self:CommentDelegate, Self: FeedItemReloadDelegate {

    func didPressLikesCount(forPost post: FeedItem) {
        // Go to likes page for post
        let vc = UsersListViewController()
        // Get liking users
        FaceSnapsClient.sharedInstance.getLikingUsers(forPost: post) { (users, error) in
            vc.users = users ?? [User]()
            vc.title = "Likes"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func didPressCommentButton(forPost post: FeedItem) {
        let vc = CommentController(post: post, delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPressUserButton(forUser user: User) {
        let vc = ProfileController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func didPressLocationButton(location: Location) {
        let fsLocation = FourSquareLocation(location: location)
        let vc = LocationPostsController(location: fsLocation)
        self.navigationController?.pushViewController(vc, animated: true)
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
                
                // Post notification that the feed item (post) has been modified
                let object = ["post": post]
                NotificationCenter.default.post(name: Notification.Name.postWasModifiedNotification, object: self, userInfo: object)
                
                likesViewCell.setLikesCount(count: post.likesCount)
            }
        }
    }
}
