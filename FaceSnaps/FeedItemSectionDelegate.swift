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
    func didTapImage(forPost post: FeedItem, imageView: UIImageView, inSectionController sectionController: FeedItemSectionController)
    
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
               
                self.postWasModifiedNotification(post: post)

                // TODO: Will the notification observer handle setting the likes count??
                likesViewCell.setLikesCount(count: post.likesCount)
            }
        }
    }

    func didTapImage(forPost post: FeedItem, imageView: UIImageView, inSectionController sectionController: FeedItemSectionController) {
        let action = FaceSnapsClient.LikeAction.like
        if post.liked {
            animateLike(imageView: imageView)
        }
        FaceSnapsClient.sharedInstance.likeOrUnlikePost(action: action, postId: post.pk) { (error) in
            if error == nil {
                // Liked post successfully
                post.liked = true
                post.likesCount += 1

                self.animateLike(imageView: imageView)
                
                // Get reference to controls cell
                guard let collectionContext = sectionController.collectionContext else { return }
                let likesViewCell = collectionContext.cellForItem(at: FeedItemSubsection.likes.rawValue, sectionController: sectionController) as! LikesViewCell
                let controlsCell = collectionContext.cellForItem(at: FeedItemSubsection.controls.rawValue, sectionController: sectionController) as! ControlsCell
                likesViewCell.setLikesCount(count: post.likesCount)
                controlsCell.setLikeButtonImage(liked: true)
            
                self.postWasModifiedNotification(post: post)
                
            } else {
                _ = APIErrorHandler.handle(error: error!, logError: true)
            }
        }
    }

    
    /// Post notification that the feed item (post) has been modified
    private func postWasModifiedNotification(post: FeedItem) {
        let object = ["post": post]
        NotificationCenter.default.post(name: .postWasModifiedNotification, object: self, userInfo: object)
    }
    
    private func animateLike(imageView: UIImageView) {
        let heartView = UIImageView(image: #imageLiteral(resourceName: "big_heart"))
        let center = imageView.center
        heartView.frame.size = CGSize(width: 50, height: 46)
        heartView.contentMode = .scaleAspectFit
        imageView.addSubview(heartView)
        heartView.center = CGPoint(x: center.x, y: center.y)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            heartView.transform = CGAffineTransform(scaleX: 4, y: 4)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                // Shrink heart
                heartView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (finished) in
                // Hide heart
                heartView.removeFromSuperview()
            })
        }
    }
    
}
