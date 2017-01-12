//
//  FaceSnapsClient.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import Alamofire

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
            guard let user = json["user"] as? [String: Any], let auth_token = user["auth_token"] as? String else {
                guard let errorResponse = json[Constant.JSONResponseKey.Error.errors] as? [String: String], let _ = errorResponse[Constant.JSONResponseKey.Error.title], let _ = errorResponse[Constant.JSONResponseKey.Error.message] else {
                    let errorString = "An error occurred parsing errors JSON"
                    completionHandler(false, [Constant.JSONResponseKey.Error.title: errorString])
                    return
                }
                completionHandler(false, errorResponse)
                return
            }
            
            // TODO: Debugging
            print("the auth token is " + auth_token)
            
            // Store the auth token
            if FaceSnapsStrongbox.sharedInstance.archive(auth_token, key: .authToken) {
                // TODO: Post notification for userSignedIn?
                completionHandler(true, nil)
            } else {
                completionHandler(false, [Constant.ErrorResponseKey.title: "Error saving auth_token to strongbox"])
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
            guard let user = json["user"] as? [String: Any], let auth_token = user["auth_token"] as? String else {
                guard let errorResponse = json[Constant.JSONResponseKey.Error.errors] as? [String: String], let _ = errorResponse[Constant.JSONResponseKey.Error.title], let _ = errorResponse[Constant.JSONResponseKey.Error.message] else {
                    let errorString = "An error occurred parsing errors JSON"
                    completionHandler(false, [Constant.JSONResponseKey.Error.title: errorString])
                    return
                }
                completionHandler(false, errorResponse)
                return
            }
            
            // TODO: Debugging
            print("the auth token is " + auth_token)
            
            // Store the auth token
            if FaceSnapsStrongbox.sharedInstance.archive(auth_token, key: .authToken) {
                // TODO: Post notification for userSignedIn?
                completionHandler(true, nil)
            } else {
                completionHandler(false, [Constant.ErrorResponseKey.title: "Error saving auth_token to strongbox"])
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
            guard let postsJSON = json[Constant.JSONResponseKey.Post.posts] as? [Any] else {
                let errorString = "Invalid JSON response: missing posts key"
                completionHandler(false, [Constant.ErrorResponseKey.title: errorString])
                return
            }
            
            // Parse postsJSON 
            // TODO: Store as an array of dictionaries and return via completion handler?
            // Or set as an object inside of the DataManager (lastFeed) and cache it? ??
            completionHandler(true, nil)

        }
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
}
