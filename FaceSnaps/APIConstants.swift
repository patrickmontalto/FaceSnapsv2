//
//  APIConstants.swift
//  FaceSnaps
//
//  Created by Patrick on 1/4/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

struct APIConstants {
    
    // Unreachable initializer
    private init() {}
    
    // MARK: - Clients
    enum Client:String {
        case facesnaps
    }
    
    // MARK: - HTTPMethods
    enum HTTPMethod:String {
        case get, put, post, delete
    }
    
    // MARK: - HTTP Header Keys
    enum HTTPHeaderKey {
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let authorization = "Authorization"
    }
    
    // MARK: HTTP Header Values
    enum HTTPHeaderValue: String {
        case applicationJSON = "application/json"
        case token = "Token token=" // TODO: should be Token token=APIkey
    }
}
