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
    enum HTTPHeaderKey:String {
        case contentType = "Content-Type"
        case accept = "Accept"
        case authorization = "Authorization"
    }
    
    // MARK: HTTP Header Values
    enum HTTPHeaderValue: String {
        case applicationJSON = "application/json"
        case token = "Token token=" // TODO: should be Token token=APIkey
    }
}
