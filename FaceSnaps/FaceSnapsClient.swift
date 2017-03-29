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
import CoreLocation

// MARK: - Face Snaps Client: NSObject

class FaceSnapsClient: NSObject {
        
    // MARK: - Properties

    // MARK: - Singleton
    static let sharedInstance = FaceSnapsClient()
    
    // MARK: - Private Init
    private override init() {}
    
    // MARK: Sign in as a user
    func signInUser(credential: String, password: String, completionHandler: @escaping (_ error: APIError?) -> Void) {
        // Build URL
        let signInEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.signInUser)
        // Build params
        let params = ["session":["credential": credential, "password": password]]
        // Make request
        Alamofire.request(signInEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            // GUARD: Get JSON
            guard let json = FaceSnapsParser.getJSON(fromResponse: response) else {
                completionHandler(.noJSON)
                return
            }
            
            // GUARD: Get and print the auth_token
            guard let user = json["user"] as? [String: Any], let authToken = user[Constant.JSONResponseKey.User.authToken] as? String else {
                guard let errorResponse = json[Constant.JSONResponseKey.Error.errors] as? [String: String], let errorMessage = errorResponse[Constant.JSONResponseKey.Error.message]  else {
                    completionHandler(.parseError(message: nil))
                    return
                }
                completionHandler(.responseError(message: errorMessage))
                return
            }
            
            // GUARD: Is there a username and full name?
            guard let pk = user[Constant.JSONResponseKey.User.id] as? Int, let fullName = user[Constant.JSONResponseKey.User.fullName] as? String, let email = user[Constant.JSONResponseKey.User.email] as? String, let userName = user[Constant.JSONResponseKey.User.username] as? String else {
                completionHandler(APIError.missingKey(message: nil))
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
            
            guard let postsCount = user[FaceSnapsClient.Constant.JSONResponseKey.User.postsCount] as? Int else {
                completionHandler(.parseError(message: nil))
                return
            }
            
            guard let followersCount = user[FaceSnapsClient.Constant.JSONResponseKey.User.followersCount] as? Int else {
                completionHandler(.parseError(message: nil))
                return
            }
            
            guard let followingCount = user[FaceSnapsClient.Constant.JSONResponseKey.User.followingCount] as? Int else {
                completionHandler(.parseError(message: nil))
                return
            }
            
            guard let privateProfile = user[FaceSnapsClient.Constant.JSONResponseKey.User.privateProfile] as? Bool else {
                completionHandler(.parseError(message: nil))
                return
            }
            
            let currentUser = User(pk: pk, name: fullName, email: email, userName: userName, photoURLString: photoURLstring, authToken: authToken, postsCount: postsCount, followersCount: followersCount, followingCount: followingCount, privateProfile: privateProfile, outgoingStatus: "none", incomingStatus: "none")
            
            // Store the user object
            if FaceSnapsDataSource.sharedInstance.setCurrentUser(asUser: currentUser) {
                completionHandler(nil)
            } else {
                completionHandler(.persistenceError)
            }
        }

    }
    
    // MARK: Refresh a user's data (GET request)
    func refreshUser(_ user: User, completionHandler: @escaping (_ error: APIError?) -> Void) {
    
        let userEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUser(user.pk))
        
        // Make request
        Alamofire.request(userEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            guard let json = FaceSnapsParser.getJSON(fromResponse: response) else {
                completionHandler(.noJSON)
                return
            }

            guard let userDictionary = json[Constant.JSONResponseKey.User.user] as? [String:Any] else {
                completionHandler(APIError.missingKey(message: "Unable to get user dictionary"))
                return
            }
            do {
                try FaceSnapsDataSource.sharedInstance.realm.write({
                    user.update(userDictionary: userDictionary)
                    completionHandler(nil)
                })
            } catch {
                completionHandler(APIError.persistenceError)
            }
            
        }
    }
    
    // MARK: Refresh the current user data (GET request)
    func refreshCurrentUser(completionHandler: @escaping (_ error: APIError?) -> Void) {
        let userEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getCurrentUser)
        
        // Make request
        Alamofire.request(userEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            guard let json = FaceSnapsParser.getJSON(fromResponse: response) else {
                completionHandler(.noJSON)
                return
            }
            
            guard let userDictionary = json[Constant.JSONResponseKey.User.user] as? [String:Any] else {
                completionHandler(APIError.missingKey(message: "Unable to get user dictionary"))
                return
            }
            do {
                try FaceSnapsDataSource.sharedInstance.realm.write({
                    FaceSnapsDataSource.sharedInstance.currentUser!.update(userDictionary: userDictionary)
                    completionHandler(nil)
                })
            } catch {
                completionHandler(APIError.persistenceError)
            }
        }
    }
    
    // MARK: Sign up as a new user
    func signUpUser(username: String, email: String, fullName: String, password: String, profileImage: String?, completionHandler: @escaping (_ error: APIError?) -> Void ) {
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
                completionHandler(APIError.responseError(message: "Error calling POST on sign up"))
                return
            }
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(APIError.noJSON)
                return
            }

            // GUARD: Get and print the auth_token
            guard let user = json["user"] as? [String: Any], let authToken = user[Constant.JSONResponseKey.User.authToken] as? String else {
                guard let errorResponse = json[Constant.JSONResponseKey.Error.errors] as? [String: String], let message = errorResponse[Constant.JSONResponseKey.Error.message] else {
                    completionHandler(APIError.parseError(message: nil))
                    return
                }
                completionHandler(APIError.responseError(message: message))
                return
            }
            
            // GUARD: Is there a username and full name?
            guard let pk = user[Constant.JSONResponseKey.User.id] as? Int, let fullName = user[Constant.JSONResponseKey.User.fullName] as? String, let email = user[Constant.JSONResponseKey.User.email] as? String, let userName = user[Constant.JSONResponseKey.User.username] as? String else {
                let errorString = "Invalid JSON response: missing key"
                completionHandler(APIError.missingKey(message: nil))
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
            
            let currentUser = User(pk: pk, name: fullName, email: email, userName: userName, photoURLString: photoURLstring, authToken: authToken, postsCount: 0, followersCount: 0, followingCount: 0, privateProfile: false, outgoingStatus: "none", incomingStatus: "none")
            
            // Store the user object
            if FaceSnapsDataSource.sharedInstance.setCurrentUser(asUser: currentUser) {
                completionHandler(nil)
            } else {
                completionHandler(APIError.persistenceError)
            }
        }
    }
    // MARK: Check if username/email is available
    func checkAvailability(forUserCredential userCredential: String, completionHandler: @escaping (_ available: Bool?, _ error: APIError?) -> Void ) {
        // Build URL
        let checkEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.checkAvailability)
        // Build params
        let params = ["user_credential": userCredential]
        // Make request
        Alamofire.request(checkEndpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                let message = "Error calling GET on check availability"
                completionHandler(nil, APIError.responseError(message: message))
                return
            }
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // GUARD: Get and return whether or not it is available
            guard let available = json[Constant.JSONResponseKey.User.available] as? Bool else {
                completionHandler(nil, APIError.missingKey(message: nil))
                return
            }
            
            completionHandler(available, nil)
        }

    }
    // MARK: Get latest feed for the user
    func getUserFeed(atPage page: Int, completionHandler: @escaping (_ data: List<FeedItem>?, _ error: APIError?) -> Void) {
        // TODO: Remove success Bool and replace with just data
        
        // Build URL
        let userFeedEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUserFeed)
     
        let pageParam = ["page": page]

        // Make request
        Alamofire.request(userFeedEndpoint, method: .get, parameters: pageParam, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                let message = "Error calling GET on user feed"
                completionHandler(nil, APIError.responseError(message: message))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // GUARD: Is there a posts array?
            guard let postsJSON = json[Constant.JSONResponseKey.Post.posts] as? [[String:Any]] else {
                let errorString = "Invalid JSON response: missing posts key"
                completionHandler(nil, APIError.missingKey(message: errorString))
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
                    completionHandler(latestFeed, nil)
                } else {
                    completionHandler(nil, APIError.parseError(message: "Error parsing posts JSON"))
                }
            }
        }
    }
    
    // MARK: Get a users posts
    func getUserFeed(forUser user: User, atPage page: Int, completionHandler: @escaping ( _ data: List<FeedItem>?, _ error: APIError?) -> Void) {
        // TODO: Remove success Bool and replace with just data
        
        // Build URL
        let userFeedEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUserFeed)
        
        let pageParam = ["page": page]
        
        // Make request
        Alamofire.request(userFeedEndpoint, method: .get, parameters: pageParam, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                let message = response.result.error!.localizedDescription
                completionHandler(nil, APIError.responseError(message: message))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // GUARD: Is there a posts array?
            guard let postsJSON = json[Constant.JSONResponseKey.Post.posts] as? [[String:Any]] else {
                let errorString = "Invalid JSON response: missing posts key"
                completionHandler(nil, APIError.missingKey(message: errorString))
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
                    completionHandler(latestFeed, nil)
                } else {
                    completionHandler(nil, APIError.parseError(message: "Error parsing posts JSON"))
                }
            }
        }
    }
    
    // MARK: Get liked posts for the user
    func getLikedPosts(atPage page: Int, completionHandler: @escaping (_ data: [FeedItem]?, APIError?) -> Void) {
        // Build URL
        let likedPostsEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.likedPosts)
        
        let pageParam = ["page": page]
        
        // Make request
        Alamofire.request(likedPostsEndpoint, method: .get, parameters: pageParam, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                let message = response.result.error!.localizedDescription
                completionHandler(nil, APIError.responseError(message: message))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // GUARD: Is there a posts array?
            guard let postsArray = json[Constant.JSONResponseKey.Post.posts] as? [[String: Any]] else {
                completionHandler(nil, APIError.missingKey(message: "Missing posts response from server."))
                return
            }
            
            // Parse the postsArray
            if let postsResult = FaceSnapsParser.parse(postsArray: postsArray) {
                completionHandler(Array(postsResult), nil)
            } else {
                completionHandler(nil, nil)
            }
            
        }
    }
    
    // MARK: Get data for a single post
    func getPostData(postId: Int, completionHandler: @escaping ( _ data: FeedItem?, _ error: APIError?) -> Void) {
        
        // Build URL
        let postDataEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.PostsEndpoint.getPost(postId))
        
        // Make request
        Alamofire.request(postDataEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                let message = response.result.error!.localizedDescription
                completionHandler(nil, APIError.responseError(message: message))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            guard let postJSON = json["post"] as? [String: Any] else {
                completionHandler(nil, APIError.parseError(message: "Missing post key."))
                return
            }

            // GUARD: Is there a post dictionary?
            if let post = FaceSnapsParser.parse(postDictionary: postJSON) {
                completionHandler(post, nil)
            } else {
                completionHandler(nil, APIError.parseError(message: "Unable to parse post data."))
            }
        }
    }
    
    // MARK: Submit a new post
    func submitPost(post: FeedItemPrototype, completionHandler: @escaping(_ success: Bool) -> Void) {
        let submitPostEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.PostsEndpoint.submitPost)
        let params = post.params
        // Make request
        Alamofire.request(submitPostEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(false)
                return
            }
            
            guard response.response?.statusCode == 201 else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
            
        }
    }
    
    // MARK: Get a list of posts IDs for the user
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
    func searchUsers(queryString: String, completionHandler: @escaping (_ data: [User]?, _ error: APIError?) -> Void) {
        let userSearchEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUsersQuery)
        
        let params = ["query": queryString]
        
        // Make request
        Alamofire.request(userSearchEndpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(nil, APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            guard let usersArray = json[Constant.JSONResponseKey.User.users] as? [[String:Any]] else {
                completionHandler(nil, nil)
                return
            }
            
            let userResults = FaceSnapsParser.parse(usersArray: usersArray)
            
            completionHandler(userResults, nil)
        }
    }

    // MARK: Get information about the owner of the access token (user)
    
    // MARK: Put an update on the current user (PUT request)
    func updateCurrentUserProfile(withAttributes params: [String: Any], completionHandler: @escaping (_ error: APIError?) -> Void) {
        let updateEndpoint = FaceSnapsClient.urlString(forEndpoint: FaceSnapsClient.Constant.APIMethod.UserEndpoint.updateUserProfile)
        
        // Make request
        Alamofire.request(updateEndpoint, method: .put, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(.noJSON)
                return
            }
            
            // GUARD: Was it a success?
            guard let userDictionary = json[Constant.JSONResponseKey.User.user] as? [String: Any] else {
                completionHandler(APIError.missingKey(message: "Missing user key from server response"))
                return
            }
            
            // Update current user (photo / name / username / email / private )
            try! FaceSnapsDataSource.sharedInstance.realm.write {
                FaceSnapsDataSource.sharedInstance.currentUser!.update(userDictionary: userDictionary)
                completionHandler(nil)
            }
            
        }
    }
    
    // MARK: Change user password
    func changeUserPassword(params: [String: String], completionHandler: @escaping (_ error: APIError?) -> Void) {
        let changePasswordEndpoint = FaceSnapsClient.urlString(forEndpoint: FaceSnapsClient.Constant.APIMethod.UserEndpoint.changePassword)
        
        // Make request
        Alamofire.request(changePasswordEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            // GUARD: Error?
            guard response.result.error == nil else {
                completionHandler(.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: JSON Response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(.noJSON)
                return
            }
            guard let meta = json[Constant.JSONResponseKey.Meta.meta] as? [String: Any],
                let code = meta[Constant.JSONResponseKey.Meta.code] as? Int, code == 200 else {
                if let error = json["error"] as? String {
                    completionHandler(APIError.responseError(message: error))
                } else {
                    completionHandler(APIError.responseError(message: nil))
                }
                return
            }

            completionHandler(nil)
        }
    }
    
    // MARK: Set a like on a post by the current user
    func likeOrUnlikePost(action: LikeAction, postId: Int, completionHandler: @escaping (_ error: APIError?) -> Void) {
        let likeEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.LikesEndpoint.likePost(postId: postId))
        
        let method: HTTPMethod = action == .like ? .post : .delete
        
        // Make request
        Alamofire.request(likeEndpoint, method: method, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                completionHandler(APIError.noJSON)
                return
            }
            
            // GUARD: Was it a success?
            guard let meta = json["meta"] as? [String: Any], let code = meta["code"] as? Int, code == 200 else {
                completionHandler(APIError.responseError(message: nil))
                return
            }
            
            completionHandler(nil)
        }
        
    }
    
    // MARK: Get the list of users a user is followed by
    func getFollowedByForUser(user: User, completionHandler: @escaping (_ data: [User]?, _ error: APIError?) -> Void ) {
        let followersEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.RelationshipsEndpoint.followedBy(userId: user.pk))
        
        // Make request
        Alamofire.request(followersEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(nil, APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Successful JSON response?
            guard let json = response.result.value as? [String:Any], let usersJson = json[Constant.JSONResponseKey.User.users] as? [[String:Any]] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            let users = FaceSnapsParser.parse(usersArray: usersJson)
            
            completionHandler(users, nil)
        }
    }
    
    // MARK: Get a list of users a user follows
    func getFollowingForUser(user: User, completionHandler: @escaping (_ data: [User]?, _ error: APIError?) -> Void ) {
        let followersEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.RelationshipsEndpoint.followers(userId: user.pk))
        
        // Make request
        Alamofire.request(followersEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(nil, APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Successful JSON response?
            guard let json = response.result.value as? [String:Any], let usersJson = json[Constant.JSONResponseKey.User.users] as? [[String:Any]] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            let users = FaceSnapsParser.parse(usersArray: usersJson)
            
            completionHandler(users, nil)
        }
    }
    
    // MARK: Modify the relationship with target user
    func modifyRelationship(action: FollowAction, user: User, completionHandler: @escaping (_ result: FollowResult?, _ error: APIError?) -> Void) {
        let modifyRelationshipEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.RelationshipsEndpoint.relationship(userId: user.pk))
        
        // Build params
        let params = ["user_action": action.rawValue]
        
        // Make request
        Alamofire.request(modifyRelationshipEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(nil, APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: JSON repsonse?
            guard let json = response.result.value as? [String:Any] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // Data or error?
            guard let data = json["data"] as? [String:Any], let status = data["outgoing_status"] as? String else {
                if let error = json["errors"] as? String {
                    completionHandler(nil, APIError.responseError(message: error))
                } else {
                    completionHandler(nil, APIError.responseError(message: nil))
                }
                return
            }
            
            // status response
            let result = FollowResult(rawValue: status)
            
            completionHandler(result, nil)
        }
    }
    
    
    
    // MARK: Get a list of users who have liked a post
    func getLikingUsers(forPost post: FeedItem, completionHandler: @escaping (_ data: [User]?, _ error: APIError?) -> Void) {
        let likingUsersEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.LikesEndpoint.likePost(postId: post.pk))
        
        // Make request
        Alamofire.request(likingUsersEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            guard let json = FaceSnapsParser.getJSON(fromResponse: response) else {
                completionHandler(nil, .noJSON)
                return
            }
            
            guard let usersArray = json[Constant.JSONResponseKey.User.users] as? [[String:Any]] else {
                completionHandler(nil, APIError.missingKey(message: "Missing users key."))
                return
            }
            
            let users = FaceSnapsParser.parse(usersArray: usersArray)
            
            completionHandler(users, nil)
        }
    }
    
    // MARK: Create a comment on a post (as the current user)
    func postComment(onPost post: FeedItem, withText text: String, completionHandler: @escaping (_ data: Comment?, _ error: APIError?) -> Void) {
        let postCommentEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.CommentsEndpoint.postComment(postId: post.pk))
        
        // Build params
        let params = ["comment": ["text": text]]
        
        // Make request
        Alamofire.request(postCommentEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(nil, APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Do we have a successful json response?
            guard let json = response.result.value as? [String:Any], let meta = json[Constant.JSONResponseKey.Meta.meta] as? [String:Any], let code = meta[Constant.JSONResponseKey.Meta.code] as? Int, code == 200 else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // GUARD: Do we have a comment in the json?
            guard let commentJson = json[Constant.JSONResponseKey.Comment.comment] as? [String: Any] else {
                completionHandler(nil, APIError.missingKey(message: nil))
                return
            }
            
            guard let comment = FaceSnapsParser.parse(commentDictionary: commentJson, forUser: FaceSnapsDataSource.sharedInstance.currentUser!) else {
                completionHandler(nil, APIError.missingKey(message: nil))
                return
            }
            
            completionHandler(comment, nil)
        }
        
    }
    
    // MARK: Remove a comment on a post (as the current user)
    
    // MARK: Get a list of comments on a post (*paginated in reverse)
    func getComments(forPost post: FeedItem, completionHandler: @escaping (_ data: [Comment]?, _ error: APIError?) -> Void) {
        let getCommentsEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.CommentsEndpoint.getComments(postId: post.pk))
        
        // Make Request
        Alamofire.request(getCommentsEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(nil, APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String:Any], let commentsJSON = json[Constant.JSONResponseKey.Comment.comments] as? [[String:Any]] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // Parse the array of comments
            guard let comments = FaceSnapsParser.parse(commentsArray: commentsJSON) else {
                completionHandler(nil, APIError.parseError(message: nil))
                return
            }
            
            completionHandler(comments.reversed(), nil)
        }
    }
    
    // MARK: - Get User Posts
    func getUserPosts(user: User, completionHandler: @escaping(_ data: List<FeedItem>?, _ error: APIError?) -> Void) {
        let getUserMediaEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.UserEndpoint.getUserMedia(userId: user.pk))
        
        // Make request
        Alamofire.request(getUserMediaEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                completionHandler(nil, APIError.responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String:Any], let postsJSON = json[Constant.JSONResponseKey.Post.posts] as? [[String:Any]] else {
                completionHandler(nil, APIError.noJSON)
                return
            }
            
            // Parse postsJSON
            guard let postsResults = FaceSnapsParser.parse(postsArray: postsJSON) else {
                completionHandler(nil, APIError.parseError(message: "Error parsing posts response from server."))
                return
            }
            
            completionHandler(postsResults, nil)
        }
    }
    
    // MARK: - Get Locations
    func getLocations(query: String, coordinate: CLLocationCoordinate2D, completionHandler: @escaping([FourSquareLocation]?, APIError?) -> Void) {
        
        let locationEndpoint = FaceSnapsClient.urlString(forEndpoint: Constant.APIMethod.LocationsEndpoint.search)
        let params: [String: Any] = ["query": query, "lat": coordinate.latitude, "lng": coordinate.longitude]
        
        // Make Request
        Alamofire.request(locationEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: Constant.AuthorizationHeader).responseJSON { (response) in
            
            // GUARD: Error?
            guard response.result.error == nil else {
                completionHandler(nil, .responseError(message: response.result.error!.localizedDescription))
                return
            }
            
            // GUARD: Do we have a json response ?
            guard let json = response.result.value as? [String:Any], let dataJSON = json[Constant.JSONResponseKey.Location.data] as? [[String:Any]] else {
                completionHandler(nil, .noJSON)
                return
            }
            
            // Parse dataJSON
            let fourSquareLocations = FaceSnapsParser.parse(fsLocationsArray: dataJSON)
            
            completionHandler(fourSquareLocations, nil)
            
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
