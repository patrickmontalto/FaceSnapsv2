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
    func signInUser(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let signInEndpoint = urlString(forEndpoint: Constant.APIMethod.UserEndpoint.signInUser)
        let params = ["session":["email": email, "password": password]]
        Alamofire.request(signInEndpoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            // TODO: Store auth key in FaceSnapsStoragebox
            // GUARD: Was there an error?
            guard response.result.error == nil else {
                print("Error calling GET on sign in")
                completionHandler(false, response.result.error!.localizedDescription)
                return
            }
            // GUARD: Do we have a json response?
            guard let json = response.result.value as? [String: Any] else {
                let errorString = "Unable to get results as JSON from API"
                completionHandler(false, errorString)
                return
            }
            // GUARD: Get and print the auth_token
            guard let user = json["user"] as? [String: Any], let auth_token = user["auth_token"] as? String else {
                let errorString = "Could not get user or auth_token from json response"
                completionHandler(false, errorString)
                return
            }
            // TODO: Debugging
            print("the auth token is " + auth_token)
            
            // Store the auth token
            if FaceSnapsStrongbox.sharedInstance.archive(auth_token, key: .authToken) {
                completionHandler(true, nil)
            } else {
                completionHandler(false, "Error saving auth_token to strongbox")
            }
        }

    }
    
    // MARK: Sign up as a new user
    
    // MARK: Get latest news feed for the user
    
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
