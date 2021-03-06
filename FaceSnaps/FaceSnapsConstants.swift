//
//  FaceSnapsConstants.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

enum FollowAction: String {
    case follow, unfollow, approve, ignore
}

enum FollowResult: String {
    case follows, none, requested
}

extension FaceSnapsClient {
    enum Environment {
        case production, development
    }
    
    enum LikeAction {
        case like, unlike
    }
    
    // MARK: - Set Application Environment
    static let ApplicationEnvironment: Environment = .production
    
    enum Constant {
        static let ApiScheme = "http"
        static let ApiHost = FaceSnapsClient.ApplicationEnvironment == .production ? "192.168.2.14" : "localhost"//"67.81.24.198"
        static let ApiPort: NSNumber? = FaceSnapsClient.ApplicationEnvironment == .production ? 81 : 3000// 81
        static let ApiPath = ""
        static let ApiKey = ""
        static let ClientType = APIConstants.Client.facesnaps
        static var AuthorizationHeader: [String: String] {
            get {
                return [APIConstants.HTTPHeaderKey.authorization: FaceSnapsDataSource.sharedInstance.authToken!]
            }
        }
        static let CurrentUserId = FaceSnapsDataSource.sharedInstance.currentUser!.pk
        
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
                // Update a users profile
                static let updateUserProfile = "/users/\(CurrentUserId)"
                // Get current user's feed
                static let getUserFeed = "/users/self/feed"
                // Get an array of all post IDs on the users feed
                static let getUserFeedIds = "/users/self/feed/post_ids"
                // Get current user
                static let getCurrentUser = "/users/self"
                // Get information about a user
                static func getUser(_ userId: Int) -> String {
                    return "/users/\(userId)"
                }
                // Get most recently liked posts by the current user (*paginated)
                // static let getCurrentUserLikedMedia = "/users/self/posts/liked"
                // Get most recent posts of a user (*paginated)
                static func getUserMedia(userId: Int) -> String {
                    return "/users/\(userId)/posts/recent"
                }
                // Search for a user by name (*paginated)
                static let getUsersQuery = "/user/search"
                static let changePassword = "/users/self/change_password"
                static let likedPosts = "/users/self/posts/liked"
                
            }
            
            enum RelationshipsEndpoint {
                static func followers(userId: Int) -> String {
                    return "/users/\(userId)/follows"
                }
                static func followedBy(userId: Int) -> String {
                    return "/users/\(userId)/followed-by"
                }
                static func relationship(userId: Int) -> String {
                    return "/users/\(userId)/relationship"
                }
            }
            
            enum PostsEndpoint {
                // GET post data
                static func getPost(_ postId: Int) -> String {
                    return "/posts/\(postId)"
                }
                // POST post data
                static let submitPost = "/users/self/posts"
            }
            
            enum LikesEndpoint {
                static func likePost(postId: Int) -> String {
                    return "/posts/\(postId)/likes"
                }
                static func unlikePost(postId: Int) -> String {
                    return likePost(postId: postId)
                }
                static func getPostLikes(postId: Int) -> String {
                    return likePost(postId: postId)
                }
            }

            enum CommentsEndpoint {
                static func getComments(postId: Int) -> String {
                    return "/posts/\(postId)/comments"
                }
                static func postComment(postId: Int) -> String {
                    return "/posts/\(postId)/comments"
                }
                static func deleteComment(postId: Int, commentId: Int) -> String {
                    return "/posts/\(postId)/comments/\(commentId)"
                }
            }

            enum TagsEndpoint {
                static let search = "/tags/search"
                static func getTagPosts(tagName: String) -> String {
                    return "/tags/\(tagName)/posts/recent"
                }
            }
            
            enum LocationsEndpoint {
                static func getLocation(id: Int) -> String {
                    return "/locations/\(id)"
                }
                static func getLocationPosts(venueId: String) -> String {
                    return "/locations/\(venueId)/posts/recent"
                }
                static let search = "/locations/search"
            }
        }
        
        // MARK: - JSON Response Keys
        enum JSONResponseKey {
            
            enum Meta {
                static let meta = "meta"
                static let code = "code"
            }
            
            // MARK: - Error
            enum Error {
                static let errors = "errors"
                static let title = "title"
                static let message = "message"
            }
            
            // MARK: - User Data
            enum User {
                static let user = "user"
                static let users = "users"
                static let id = "id"
                static let username = "username"
                static let fullName = "full_name"
                static let email = "email"
                static let authToken = "auth_token"
                static let available = "available"
                static let photoPath = "photo_path"
                static let following = "following"
                static let postsCount = "posts_count"
                static let followersCount = "followers_count"
                static let followingCount = "following_count"
                static let privateProfile = "private"
                static let relationship = "relationship"
                static let incomingStatus = "incoming_status"
                static let outgoingStatus = "outgoing_status"
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
                static let createdAt = "created_at"
                static let postsIds = "posts_ids"
                static let location = "location"
            }
            
            // MARK: - Comments Data
            enum Comment {
                static let id = "id"
                static let user = "user"
                static let text = "text"
                static let comments = "comments"
                static let comment = "comment"
                static let createdAt = "created_at"
            }
            
            // MARK: - Tags Data
            enum Tag {
                static let tags = "tags"
                static let id = "id"
                static let name = "name"
                static let postsCount = "posts_count"
            }
            
            // MARK: - Locations Data
            enum Location {
                static let data = "data"
                static let id = "id"
                static let venueId = "venue_id"
                static let name = "name"
                static let latitude = "lat"
                static let longitude = "lng"
                static let address = "addr"
                static let city = "city"
            }
            
            // MARK: - Pagination (should be header response)
        }
    }
    
    // MARK: - HTTP Header Response Keys
    enum HTTPHeaderResponseKey {
        
    }
    
    
}
