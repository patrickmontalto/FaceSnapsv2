//
//  FaceSnapsConstants.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

extension FaceSnapsClient {
    
    enum Environment {
        case production, development
    }

    // MARK: - Set Application Environment
    static let ApplicationEnvironment: Environment = .development
    
    enum Constant {
        static let ApiScheme = "http"
        static let ApiHost = FaceSnapsClient.ApplicationEnvironment == .production ? "TBD" : "localhost"//"67.81.24.198"
        static let ApiPort: NSNumber? = FaceSnapsClient.ApplicationEnvironment == .production ? nil : 3000// 81
        static let ApiPath = ""
        static let ApiKey = ""
        static let ClientType = APIConstants.Client.facesnaps
        static let AuthorizationHeader = [APIConstants.HTTPHeaderKey.authorization: FaceSnapsDataSource.sharedInstance.authToken!]
        
        enum ErrorResponseKey {
            static let error = "error"
            static let title = "title"
            static let message = "message"
        }
        
        // MARK: - API Methods
        enum APIMethod {
            enum UserEndpoint {
                // Sign up new user
                static let signUpUser = "/users/sign_up"
                // Check if a username is available
                static let checkAvailability = "/users/sign_up/check_availability"
                // Sign in with username and password
                static let signInUser = "/sessions"
                // Sign out the user
                static func signOutUser(auth_token: String) -> String {
                    return "/sessions/\(auth_token)"
                }
                // Get current user's feed
                static let getUserFeed = "/users/self/feed"
                // Get current user
                static let getCurrentUser = "/users/self"
                // Get information about a user
                static let getUser = "/users/"
                // Get most recent posts of the current user (*paginated)
                static let getCurrentUserMedia = "/users/self/posts/recent"
                // Get most recently liked posts by the current user (*paginated)
                static let getCurrentUserLikedMedia = "/users/self/posts/liked"
                // Get most recent posts of a user (*paginated)
                static func getUserMedia(userId: Int) -> String {
                    return "users/\(userId)/posts/recent"
                }
                // Search for a user by name (*paginated)
                static let getUsersQuery = "/users/search"
                
            }
            
//            enum RelationshipsEndpoint {
//                
//            }
//            
//            enum PostsEndpoint {
//                
//            }
//            
//            enum LikesEndpoint {
//                
//            }
//            
//            enum CommentsEndpoint {
//                
//            }
//            
//            enum TagsEndpoint {
//                
//            }
//            
//            enum LocationsEndpoint {
//                
//            }
        }
        
        // MARK: - JSON Response Keys
        enum JSONResponseKey {
            
            // MARK: - Error
            enum Error {
                static let errors = "errors"
                static let title = "title"
                static let message = "message"
            }
            
            // MARK: - User Data
            enum User {
                static let user = "user"
                static let id = "id"
                static let username = "username"
                static let fullName = "full_name"
                static let email = "email"
                static let authToken = "auth_token"
                static let available = "available"
                static let photoPath = "photo_path"
            }
            // MARK: - Relationship Data
            
            // MARK: - Post data
            enum Post {
                static let id = "id"
                static let user = "user"
                static let caption = "caption"
                static let posts = "posts"
                static let photo = "photo"
                static let base64Image = "base64_image"
                static let photoPath = "photo_path"
                static let comments = "comments"
                static let likedByUser = "liked_by_user"
                static let likes = "likes"

            }
            
            // MARK: - Comments Data
            enum Comment {
                static let id = "id"
                static let user = "user"
                static let text = "text"
            }
            
            // MARK: - Tags Data
            enum Tag {
                static let id = "id"
                static let name = "name"
            }
            
            // MARK: - Locations Data
            
            // MARK: - Pagination (should be header response)
        }
    }
    
    // MARK: - HTTP Header Response Keys
    enum HTTPHeaderResponseKey {
        
    }
    
    
}
