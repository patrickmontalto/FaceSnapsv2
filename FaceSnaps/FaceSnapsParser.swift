//
//  FaceSnapsParser.swift
//  FaceSnaps
//
//  Created by Patrick on 2/6/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import RealmSwift

enum FaceSnapsParser {
    // MARK: - Parse Methods
    
    static func parse(userDictionary: [String: Any]) -> User? {
        // GUARD: Get and print the auth_token
        guard let authToken = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.authToken] as? String else {
            return nil
        }
        
        // GUARD: Is there a username and full name?
        guard let pk = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.id] as? Int, let fullName = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.fullName] as? String, let userName = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.username] as? String else {
            return nil
        }
        
        var photoURLstring: String? = nil
        
        if let photoPath = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.photoPath] as? String {
            photoURLstring = FaceSnapsClient.urlString(forPhotoPath: photoPath)
        }
        
        return User(pk: pk, name: fullName, userName: userName, photoURLString: photoURLstring, authToken: authToken)
    }
    
    // TODO: Parse Comments Array
    static func parse(commentsArray: [[String:Any]]) -> List<Comment>? {
        // GUARD: Does the comment have a user?
        let list = List<Comment>()
        
        for comment in commentsArray {
            // GUARD: Does the comment have an ID?
            guard let pk = comment[FaceSnapsClient.Constant.JSONResponseKey.Comment.id] as? Int else {
                continue
            }
            
            // GUARD: Does the comment have a user?
            guard let userDictionary = comment[FaceSnapsClient.Constant.JSONResponseKey.Comment.user] as? [String: Any] else {
                continue
            }
            
            // Parse user
            guard let user = parse(userDictionary: userDictionary) else {
                continue
            }
            
            // GUARD: Does the comment have text?
            guard let text = comment[FaceSnapsClient.Constant.JSONResponseKey.Comment.text] as? String else {
                continue
            }
            
            // Date formatting
            guard let createdAt = comment[FaceSnapsClient.Constant.JSONResponseKey.Comment.createdAt] as? String else {
                continue
            }
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            guard let datePosted = formatter.date(from: createdAt) else {
                continue
            }
            
            let comment = Comment(pk: pk, author: user, text: text, datePosted: datePosted)
            
            list.append(comment)
        }
        
        return list
    }
    
    // TODO: Parse Comments Array
    static func parse(commentDictionary: [String:Any], forUser user: User) -> Comment? {
        
        // GUARD: Does the comment have an ID?
        guard let pk = commentDictionary[FaceSnapsClient.Constant.JSONResponseKey.Comment.id] as? Int else {
            return nil
        }
        
        // GUARD: Does the comment have text?
        guard let text = commentDictionary[FaceSnapsClient.Constant.JSONResponseKey.Comment.text] as? String else {
            return nil
        }
        
        // Date formatting
        guard let createdAt = commentDictionary[FaceSnapsClient.Constant.JSONResponseKey.Comment.createdAt] as? String else {
            return nil
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let datePosted = formatter.date(from: createdAt) else {
            return nil
        }
        
        let comment = Comment(pk: pk, author: user, text: text, datePosted: datePosted)
        
        return comment
    }
    
    
    static func parse(postsArray: [[String:Any]]) -> List<FeedItem>? {
        let feedItems = List<FeedItem>()
        
        for post in postsArray {
            // GUARD: Does the post have an ID?
            guard let pk = post[FaceSnapsClient.Constant.JSONResponseKey.Post.id] as? Int else {
                continue
            }
            // GUARD: Does the post have a user?
            guard let userDictionary = post[FaceSnapsClient.Constant.JSONResponseKey.Post.user] as? [String: Any] else {
                continue
            }
            
            // Parse user
            guard let user = parse(userDictionary: userDictionary) else {
                continue
            }
            
            // GUARD: Does the post have a photo path?
            guard let photoPath = post[FaceSnapsClient.Constant.JSONResponseKey.Post.photoPath] as? String else {
                continue
            }
            
            // GUARD: Does the user like the post?
            guard let liked = post[FaceSnapsClient.Constant.JSONResponseKey.Post.likedByUser] as? Bool else {
                continue
            }
            
            // GUARD: Is there a likes array?
            guard let likes = post[FaceSnapsClient.Constant.JSONResponseKey.Post.likes] as? [[String:AnyObject]] else {
                continue
            }
            
            // GUARD: Is there a time created?
            guard let createdAt = post[FaceSnapsClient.Constant.JSONResponseKey.Post.createdAt] as? String else {
                continue
            }
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            guard let datePosted = formatter.date(from: createdAt) else {
                continue
            }
            
            let likesCount = likes.count
            
            let photoURLstring = FaceSnapsClient.urlString(forPhotoPath: photoPath)
            
            
            // GUARD: Does the post have a caption?
            guard let caption = post[FaceSnapsClient.Constant.JSONResponseKey.Post.caption] as? String else {
                continue
            }
            
            // Handle comments
            var comments = List<Comment>()
            
            if let commentsArray = post[FaceSnapsClient.Constant.JSONResponseKey.Post.comments] as? [[String:Any]] {
                if let parsedComments = parse(commentsArray: commentsArray) {
                    comments = parsedComments
                }
            }
            
            // TODO: Store post as a Post object and cache it. Can use Realm or Core Data for object mapping
            let post = FeedItem(pk: pk, user: user, caption: caption, comments: comments, photoURLString: photoURLstring, liked: liked, datePosted: datePosted, likesCount: likesCount)
            
            feedItems.append(post)
        }
        
        return feedItems
    }

}