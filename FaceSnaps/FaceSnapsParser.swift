//
//  FaceSnapsParser.swift
//  FaceSnaps
//
//  Created by Patrick on 2/6/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

enum FaceSnapsParser {
    
    static func getJSON(fromResponse response: DataResponse<Any>) -> [String:Any]? {
        // GUARD: Was there an error?
        guard response.result.error == nil else {
            print("API Response had error")
            return nil
        }
        
        // GUARD: Do we have a json response?
        guard let json = response.result.value as? [String: Any] else {
            print("Unable to get results as JSON from API")
            return nil
        }
        
        return json

    }
    
    // MARK: - Parse Methods
    
    static func parse(usersArray: [[String:Any]]) -> [User] {
        var results = [User]()
        
        for user in usersArray {
            guard let user = parse(userDictionary: user) else {
                continue
            }
            results.append(user)
        }
        
        return results
    }
    
    static func parse(userDictionary: [String: Any]) -> User? {
        // GUARD: Get and print the auth_token
        guard let authToken = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.authToken] as? String else {
            return nil
        }
        
        // GUARD: Is there a username and full name?
        guard let pk = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.id] as? Int, let fullName = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.fullName] as? String, let userName = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.username] as? String else {
            return nil
        }
        
        guard let email = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.email] as? String else {
            return nil
        }
        
        var photoURLstring: String? = nil
        
        if let photoPath = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.photoPath] as? String {
            photoURLstring = FaceSnapsClient.urlString(forPhotoPath: photoPath)
        }
        
        guard let postsCount = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.postsCount] as? Int else {
            return nil
        }
        
        guard let followersCount = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.followersCount] as? Int else {
            return nil
        }
        
        guard let followingCount = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.followingCount] as? Int else {
            return nil
        }
        
        guard let privateProfile = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.privateProfile] as? Bool else {
            return nil
        }
        
        guard let relationship = userDictionary[FaceSnapsClient.Constant.JSONResponseKey.User.relationship] as? [String: String], let outgoingStatus = relationship[FaceSnapsClient.Constant.JSONResponseKey.User.outgoingStatus], let incomingStatus = relationship[FaceSnapsClient.Constant.JSONResponseKey.User.incomingStatus] else {
            return nil
        }
        
        return User(pk: pk, name: fullName, email: email, userName: userName, photoURLString: photoURLstring, authToken: authToken, postsCount: postsCount, followersCount: followersCount, followingCount: followingCount, privateProfile: privateProfile, outgoingStatus: outgoingStatus, incomingStatus: incomingStatus)
    }
    
    /// Parse a single location
    static func parse(locationDictionary: [String:Any]) -> Location? {
        guard let id = locationDictionary[FaceSnapsClient.Constant.JSONResponseKey.Location.id] as? String else {
            return nil
        }
        guard let name = locationDictionary[FaceSnapsClient.Constant.JSONResponseKey.Location.name] as? String else {
            return nil
        }
        guard let lat = locationDictionary[FaceSnapsClient.Constant.JSONResponseKey.Location.latitude] as? Double else {
            return nil
        }
        guard let lng = locationDictionary[FaceSnapsClient.Constant.JSONResponseKey.Location.longitude] as? Double else {
            return nil
        }
        

    }
    
    /// Parses Comments Array
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
    
    static func parse(postDictionary post: [String:Any]) -> FeedItem? {
        // GUARD: Does the post have an ID?
        guard let pk = post[FaceSnapsClient.Constant.JSONResponseKey.Post.id] as? Int else {
            return nil
        }
        // GUARD: Does the post have a user?
        guard let userDictionary = post[FaceSnapsClient.Constant.JSONResponseKey.Post.user] as? [String: Any] else {
            return nil
        }
        
        // Parse user
        guard let user = parse(userDictionary: userDictionary) else {
            return nil
        }
        
        // GUARD: Does the post have a photo path?
        guard let photoPath = post[FaceSnapsClient.Constant.JSONResponseKey.Post.photoPath] as? String else {
            return nil
        }
        
        // GUARD: Does the user like the post?
        guard let liked = post[FaceSnapsClient.Constant.JSONResponseKey.Post.likedByUser] as? Bool else {
            return nil
        }
        
        // GUARD: Is there a likes array?
        guard let likes = post[FaceSnapsClient.Constant.JSONResponseKey.Post.likes] as? [[String:AnyObject]] else {
            return nil
        }
        
        // GUARD: Is there a time created?
        guard let createdAt = post[FaceSnapsClient.Constant.JSONResponseKey.Post.createdAt] as? String else {
            return nil
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let datePosted = formatter.date(from: createdAt) else {
            return nil
        }
        
        let likesCount = likes.count
        
        let photoURLstring = FaceSnapsClient.urlString(forPhotoPath: photoPath)
        
        
        // GUARD: Does the post have a caption?
        guard let caption = post[FaceSnapsClient.Constant.JSONResponseKey.Post.caption] as? String else {
            return nil
        }
        
        // Handle comments
        var comments = List<Comment>()
        
        if let commentsArray = post[FaceSnapsClient.Constant.JSONResponseKey.Post.comments] as? [[String:Any]] {
            if let parsedComments = parse(commentsArray: commentsArray) {
                comments = parsedComments
            }
        }
        
        let post = FeedItem(pk: pk, user: user, caption: caption, comments: comments, photoURLString: photoURLstring, liked: liked, datePosted: datePosted, likesCount: likesCount)
        
        return post
    }
    
    
    static func parse(postsArray: [[String:Any]]) -> List<FeedItem>? {
        let feedItems = List<FeedItem>()
        
        for post in postsArray {
            if let newPost = parse(postDictionary: post) {
                feedItems.append(newPost)
            }
        }
        
        return feedItems
    }

}
