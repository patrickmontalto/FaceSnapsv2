//
//  FaceSnapsClient.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift


// MARK: - Face Snaps Client: NSObject

class FaceSnapsClient: NSObject {
    
    // MARK: - Properties

    // MARK: - Singleton
    static let sharedInstance = FaceSnapsClient()
    
    // MARK: - Private Init
    private override init() {}
    
    // MARK: Sign in as a user
    func signInUser(credential: String, password: String, completionHandler: @escaping (_ success: Bool, _ errors: [String: String]?) -> Void) {
        // Build URL
        let signInEndpoint = urlString(forEndpoint: Constant.APIMethod.UserEndpoint.signInUser)
        // Build params
        let params = ["session":["credential": credential, "password": password]]
        // Make request
        Alamofire.request(signInEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on sign in")
                completionHandler(false, [Constant.ErrorResponseKey.title: response.result.error!.localizedDescription])
                return
            }
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            // GUARD: Get and print the auth_token
            guard let user = json["user"] as? [String: Any], let authToken = user[Constant.JSONResponseKey.User.authToken] as? String else {
                guard let errorResponse = json[Constant.JSONResponseKey.Error.errors] as? [String: String], let _ = errorResponse[Constant.JSONResponseKey.Error.title], let _ = errorResponse[Constant.JSONResponseKey.Error.message] else {
                    let errorString = "An error occurred parsing errors JSON"
                    completionHandler(false, [Constant.JSONResponseKey.Error.title: errorString])
                    return
                }
                completionHandler(false, errorResponse)
                return
            }
            
            // GUARD: Is there a username and full name?
            guard let pk = user[Constant.JSONResponseKey.User.id] as? Int, let fullName = user[Constant.JSONResponseKey.User.fullName] as? String, let userName = user[Constant.JSONResponseKey.User.username] as? String else {
                let errorString = "Invalid JSON response: missing key"
                completionHandler(false, [Constant.JSONResponseKey.Error.title: errorString])
                return
            }
            
            // TODO: Debugging
            print("the auth token is " + authToken)
            print("The full name is " + fullName)
            print("The username is " + userName)
            
            var photoURLstring: String? = nil
            
            if let photoPath = user[Constant.JSONResponseKey.User.photoPath] as? String {
                photoURLstring = self.urlString(forPhotoPath: photoPath)
            }
            
            let currentUser = User(pk: pk, name: fullName, userName: userName, photoURLString: photoURLstring, authToken: authToken)
            
            // Store the user object
            if FaceSnapsDataSource.sharedInstance.setCurrentUser(asUser: currentUser) {
                completionHandler(true, nil)
            } else {
                completionHandler(false, [Constant.ErrorResponseKey.title: "Error saving user to strongbox"])
            }
        }

    }
    
    // MARK: Sign up as a new user
    func signUpUser(username: String, email: String, fullName: String, password: String, profileImage: String?, completionHandler: @escaping (_ success: Bool, _ errors: [String: String]?) -> Void ) {
        // Build URL
        let signUpEndpoint = urlString(forEndpoint: Constant.APIMethod.UserEndpoint.signUpUser)
        // Build params
        var params: [String: Any] = ["user" : ["username": username, "email": email, "full_name": fullName, "password": password]]
        if let profileImage = profileImage {
             params = ["user" : ["username": username, "email": email, "full_name": fullName, "password": password], "photo": "data:image/jpeg;base64,\(profileImage)"]
        }
        
        // Make headers
        let headers: HTTPHeaders = [
            APIConstants.HTTPHeaderKey.contentType: "application/json",
            APIConstants.HTTPHeaderKey.accept: "application/json"
        ]
        // Make request
        Alamofire.request(signUpEndpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling POST on sign up")
                completionHandler(false, [Constant.ErrorResponseKey.title: response.result.error!.localizedDescription])
                return
            }
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false, [Constant.ErrorResponseKey.title: errorString])
                return
            }

            // GUARD: Get and print the auth_token
            guard let user = json["user"] as? [String: Any], let authToken = user[Constant.JSONResponseKey.User.authToken] as? String else {
                guard let errorResponse = json[Constant.JSONResponseKey.Error.errors] as? [String: String], let _ = errorResponse[Constant.JSONResponseKey.Error.title], let _ = errorResponse[Constant.JSONResponseKey.Error.message] else {
                    let errorString = "An error occurred parsing errors JSON"
                    completionHandler(false, [Constant.JSONResponseKey.Error.title: errorString])
                    return
                }
                completionHandler(false, errorResponse)
                return
            }
            
            // GUARD: Is there a username and full name?
            guard let pk = user[Constant.JSONResponseKey.User.id] as? Int, let fullName = user[Constant.JSONResponseKey.User.fullName] as? String, let userName = user[Constant.JSONResponseKey.User.username] as? String else {
                let errorString = "Invalid JSON response: missing key"
                completionHandler(false, [Constant.JSONResponseKey.Error.title: errorString])
                return
            }
            
            // TODO: Debugging
            print("the auth token is " + authToken)
            print("The full name is " + fullName)
            print("The username is " + userName)
            
            var photoURLstring: String? = nil
            
            if let photoPath = user[Constant.JSONResponseKey.User.photoPath] as? String {
                photoURLstring = self.urlString(forPhotoPath: photoPath)
            }
            
            let currentUser = User(pk: pk, name: fullName, userName: userName, photoURLString: photoURLstring, authToken: authToken)
            
            // Store the user object
            if FaceSnapsDataSource.sharedInstance.setCurrentUser(asUser: currentUser) {
                completionHandler(true, nil)
            } else {
                completionHandler(false, [Constant.ErrorResponseKey.title: "Error saving user to strongbox"])
            }
        }
    }
    // MARK: Check if username/email is available
    func checkAvailability(forUserCredential userCredential: String, completionHandler: @escaping (_ success: Bool, _ errors: [String: String]?) -> Void ) {
        // Build URL
        let checkEndpoint = urlString(forEndpoint: Constant.APIMethod.UserEndpoint.checkAvailability)
        // Build params
        let params = ["user_credential": userCredential]
        // Make request
        Alamofire.request(checkEndpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on check availability")
                completionHandler(false, [Constant.ErrorResponseKey.title: response.result.error!.localizedDescription])
                return
            }
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            
            // GUARD: Get and return whether or not it is available
            guard let available = json[Constant.JSONResponseKey.User.available] as? Bool else {
                let errorString = "Invalid JSON response: missing key"
                completionHandler(false, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            
            completionHandler(available, nil)
        }

    }
    // MARK: Get latest feed for the user
    func getUserFeed(completionHandler: @escaping (_ success: Bool, _ errors: [String:String]?) -> Void) {
        FaceSnapsDataSource.sharedInstance.deleteFeedItems()
        
        // Build URL
        let userFeedEndpoint = urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUserFeed)
        // Make request
        Alamofire.request(userFeedEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on user feed")
                completionHandler(false, [Constant.ErrorResponseKey.title: response.result.error!.localizedDescription])
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            
            // GUARD: Is there a posts array?
            guard let postsJSON = json[Constant.JSONResponseKey.Post.posts] as? [[String:Any]] else {
                let errorString = "Invalid JSON response: missing posts key"
                completionHandler(false, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            
            // Parse postsJSON 
            if let latestFeed = self.parse(postsArray: postsJSON) {
                // TODO: Save to realm if it is page 1 and return the feed object
                // TODO: Otherwise, just return the feed object (page 2 or more)
                _ = FaceSnapsDataSource.sharedInstance.setLatestFeed(asFeed: latestFeed)
                completionHandler(true, nil)
            } else {
                completionHandler(false, [Constant.ErrorResponseKey.title: "Error parsing posts JSON"])
            }
        }
    }
    
    // MARK: - Parse Methods
    
    private func parse(userDictionary: [String: Any]) -> User? {
        // GUARD: Get and print the auth_token
        guard let authToken = userDictionary[Constant.JSONResponseKey.User.authToken] as? String else {
            return nil
        }
        
        // GUARD: Is there a username and full name?
        guard let pk = userDictionary[Constant.JSONResponseKey.User.id] as? Int, let fullName = userDictionary[Constant.JSONResponseKey.User.fullName] as? String, let userName = userDictionary[Constant.JSONResponseKey.User.username] as? String else {
            return nil
        }
    
        var photoURLstring: String? = nil
        
        if let photoPath = userDictionary[Constant.JSONResponseKey.User.photoPath] as? String {
            photoURLstring = self.urlString(forPhotoPath: photoPath)
        }
    
        return User(pk: pk, name: fullName, userName: userName, photoURLString: photoURLstring, authToken: authToken)
    }
    
    // TODO: Parse Comments Array
    private func parse(commentsArray: [[String:Any]]) -> List<Comment>? {
        // GUARD: Does the comment have a user?
        let list = List<Comment>()
    
        for comment in commentsArray {
            // GUARD: Does the comment have an ID?
            guard let pk = comment[Constant.JSONResponseKey.Comment.id] as? Int else {
                continue
            }
            
            // GUARD: Does the comment have a user?
            guard let userDictionary = comment[Constant.JSONResponseKey.Comment.user] as? [String: Any] else {
                continue
            }
            
            // Parse user
            guard let user = parse(userDictionary: userDictionary) else {
                continue
            }
            
            // GUARD: Does the comment have text?
            guard let text = comment[Constant.JSONResponseKey.Comment.text] as? String else {
                continue
            }
            
            let comment = Comment(pk: pk, author: user, text: text)
            
            list.append(comment)
        }
        
        return list
    }
    
    private func parse(postsArray: [[String:Any]]) -> List<FeedItem>? {
        let feedItems = List<FeedItem>()
        
        for post in postsArray {
            // GUARD: Does the post have an ID?
            guard let pk = post[Constant.JSONResponseKey.Post.id] as? Int else {
                continue
            }
            // GUARD: Does the post have a user?
            guard let userDictionary = post[Constant.JSONResponseKey.Post.user] as? [String: Any] else {
                continue
            }
            
            // Parse user
            guard let user = parse(userDictionary: userDictionary) else {
                continue
            }
            
            // GUARD: Does the post have a photo path?
            guard let photoPath = post[Constant.JSONResponseKey.Post.photoPath] as? String else {
                continue
            }
            
            // GUARD: Does the user like the post?
            guard let liked = post[Constant.JSONResponseKey.Post.likedByUser] as? Bool else {
                continue
            }
            
            // GUARD: Is there a likes array?
            guard let likes = post[Constant.JSONResponseKey.Post.likes] as? [[String:AnyObject]] else {
                continue
            }
            
            let likesCount = likes.count
            
            let photoURLstring = self.urlString(forPhotoPath: photoPath)


            // GUARD: Does the post have a caption?
            guard let caption = post[Constant.JSONResponseKey.Post.caption] as? String else {
                continue
            }
            
            // Handle comments
            var comments = List<Comment>()
            
            if let commentsArray = post[Constant.JSONResponseKey.Post.comments] as? [[String:Any]] {
                if let parsedComments = parse(commentsArray: commentsArray) {
                    comments = parsedComments
                }
            }
            
            // TODO: Store post as a Post object and cache it. Can use Realm or Core Data for object mapping
            let post = FeedItem(pk: pk, user: user, caption: caption, comments: comments, photoURLString: photoURLstring, liked: liked, likesCount: likesCount)
            
            feedItems.append(post)
        }
        
        return feedItems
    }
    
    // MARK: Get information about the owner of the access token (user)
    
    // MARK: Get information about a user
    
    // MARK: Set a like on a post by the current user
    
    // MARK: Remove a like on a post by the current user
    
    // MARK: Get a list of users who have liked a post
    
    // MARK: Create a comment on a post (as the current user)
    
    // MARK: Remove a comment on a post (as the current user)
    
    // MARK: Get a list of comments on a post (*paginated in reverse)
    
    // MARK: Build URL
    private func urlString(forEndpoint endpoint: String) -> String {
        return APIClient.buildURLString(scheme: Constant.ApiScheme, host: Constant.ApiHost, port: Constant.ApiPort, clientType: .facesnaps, endpoint: endpoint)
    }
    
    // MARK: Build Photo URL
    private func urlString(forPhotoPath photoPath: String) -> String {
        return APIClient.buildURLString(scheme: Constant.ApiScheme, host: Constant.ApiHost, port: Constant.ApiPort, clientType: .facesnaps, endpoint: photoPath)
    }
}
