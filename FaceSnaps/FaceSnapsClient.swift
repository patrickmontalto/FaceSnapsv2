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
        let signInEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.signInUser)
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
                photoURLstring = FaceSnapsClient.urlString(forPhotoPath: photoPath)
            }
            
            let currentUser = User(pk: pk, name: fullName, userName: userName, photoURLString: photoURLstring, authToken: authToken, isFollowing: false)
            
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
        let signUpEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.signUpUser)
        // Build params
        var params: [String: Any] = ["user" : ["username": username, "email": email, "full_name": fullName, "password": password]]
        if let profileImage = profileImage {
             params = ["user" : ["username": username, "email": email, "full_name": fullName, "password": password], "photo": "data:image/jpeg;base64,\(profileImage)"]
        }
        
        print(params["photo"]!)
        
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
                photoURLstring = FaceSnapsClient.urlString(forPhotoPath: photoPath)
            }
            
            let currentUser = User(pk: pk, name: fullName, userName: userName, photoURLString: photoURLstring, authToken: authToken, isFollowing: false)
            
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
        let checkEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.checkAvailability)
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
    func getUserFeed(atPage page: Int, completionHandler: @escaping (_ success: Bool, _ data: List<FeedItem>?, _ errors: [String:String]?) -> Void) {
        // Delete the latest feed items if we are attempting to get page 1 again
        var lastFeed: Results<FeedItem>?
        
        // TODO: Remove success Bool and replace with just data
        
        // Build URL
        let userFeedEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUserFeed)
     
        let pageParam = ["page": page]

        // Make request
        Alamofire.request(userFeedEndpoint, method: .get, parameters: pageParam, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on user feed")
                completionHandler(false, nil, [Constant.ErrorResponseKey.title: response.result.error!.localizedDescription])
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false, nil, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            
            // GUARD: Is there a posts array?
            guard let postsJSON = json[Constant.JSONResponseKey.Post.posts] as? [[String:Any]] else {
                let errorString = "Invalid JSON response: missing posts key"
                completionHandler(false, nil, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            
            // TODO: Set posts Ids array on data source
            self.getUserFeedPostId(completionHandler: { (success) in
                
            })
            
            // Switch to background thread to parse
            DispatchQueue.global(qos: .default).async {
            
                // Parse postsJSON
                if let latestFeed = FaceSnapsParser.parse(postsArray: postsJSON) {
                    // Save JSON to Strongbox
                    FaceSnapsDataSource.sharedInstance.lastJSONdata = postsJSON
                    completionHandler(true, latestFeed, nil)
                } else {
                    completionHandler(false, nil, [Constant.ErrorResponseKey.title: "Error parsing posts JSON"])
                }
            }
        }
    }
    
    private func getUserFeedPostId(completionHandler: @escaping (_ success: Bool) -> Void) {
        let userFeedEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUserFeedIds)
        
        // Make request
        Alamofire.request(userFeedEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on user feed")
                completionHandler(false)
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false)
                return
            }
            
            // GUARD: Is there a posts array?
            guard let postsIds = json[Constant.JSONResponseKey.Post.postsIds] as? [Int] else {
                let errorString = "Invalid JSON response: missing posts key"
                completionHandler(false)
                return
            }
            
            // Set on DataSource
            FaceSnapsDataSource.sharedInstance.postKeys = postsIds
            
            completionHandler(true)

        }

    }
    
    // MARK: Search users
    func searchUsers(queryString: String, completionHandler: @escaping (_ data: [User]?) -> Void) {
        let userSearchEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUsersQuery)
        
        let params = ["query": queryString]
        
        // Make request
        Alamofire.request(userSearchEndpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on user feed")
                completionHandler(nil)
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(nil)
                return
            }
            
            guard let usersArray = json[Constant.JSONResponseKey.User.users] as? [[String:Any]] else {
                completionHandler(nil)
                return
            }
            
            let userResults = FaceSnapsParser.parse(usersArray: usersArray)
            
            completionHandler(userResults)
        }
    }

    // MARK: Get information about the owner of the access token (user)
    
    // MARK: Get information about a user
    
    // MARK: Set a like on a post by the current user
    func likeOrUnlikePost(action: LikeAction, postId: Int, completionHandler: @escaping (_ success: Bool) -> Void) {
        let likeEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.LikesEndpoint.likePost(postId: postId))
        
        let method: HTTPMethod = action == .like ? .post : .delete
        
        // Make request
        Alamofire.request(likeEndpoint, method: method, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on user feed")
                completionHandler(false)
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false)
                return
            }
            
            // GUARD: Was it a success?
            guard let meta = json["meta"] as? [String: Any], let code = meta["code"] as? Int, code == 200 else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
        
    }
    
    // MARK: Remove a like on a post by the current user
    
    // MARK: Get a list of users who have liked a post
    
    // MARK: Create a comment on a post (as the current user)
    func postComment(onPost post: FeedItem, withText text: String, completionHandler: @escaping (_ data: Comment?) -> Void) {
        let postCommentEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.CommentsEndpoint.postComment(postId: post.pk))
        
        // Build params
        let params = ["comment": ["text": text]]
        
        // Make request
        Alamofire.request(postCommentEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on user feed")
                completionHandler(nil)
                return
            }
            
            // GUARD: Do we have a successful json response?
            guard let json = response.result.value as? [String:Any], let meta = json[Constant.JSONResponseKey.Meta.meta] as? [String:Any], let code = meta[Constant.JSONResponseKey.Meta.code] as? Int, code == 200 else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(nil)
                return
            }
            
            // GUARD: Do we have a comment in the json?
            guard let commentJson = json[Constant.JSONResponseKey.Comment.comment] as? [String: Any] else {
                completionHandler(nil)
                return
            }
            
            guard let comment = FaceSnapsParser.parse(commentDictionary: commentJson, forUser: FaceSnapsDataSource.sharedInstance.currentUser!) else {
                completionHandler(nil)
                return
            }
            
            completionHandler(comment)
        }
        
    }
    
    // MARK: Remove a comment on a post (as the current user)
    
    // MARK: Get a list of comments on a post (*paginated in reverse)
    func getComments(forPost post: FeedItem, completionHandler: @escaping (_ data: [Comment]?) -> Void) {
        let getCommentsEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.CommentsEndpoint.getComments(postId: post.pk))
        
        // Make Request
        Alamofire.request(getCommentsEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on user feed")
                completionHandler(nil)
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String:Any], let commentsJSON = json[Constant.JSONResponseKey.Comment.comments] as? [[String:Any]] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(nil)
                return
            }
            
            // Parse the array of comments
            guard let comments = FaceSnapsParser.parse(commentsArray: commentsJSON) else {
                completionHandler(nil)
                return
            }
            
            completionHandler(comments.reversed())
        }
    }
    
    // MARK: Build URL
    static func urlString(forEndpoint endpoint: String) -> String {
        return APIClient.buildURLString(scheme: Constant.ApiScheme, host: Constant.ApiHost, port: Constant.ApiPort, clientType: .facesnaps, endpoint: endpoint)
    }
    
    // MARK: Build Photo URL
    static func urlString(forPhotoPath photoPath: String) -> String {
        return APIClient.buildURLString(scheme: Constant.ApiScheme, host: Constant.ApiHost, port: Constant.ApiPort, clientType: .facesnaps, endpoint: photoPath)
    }
}
