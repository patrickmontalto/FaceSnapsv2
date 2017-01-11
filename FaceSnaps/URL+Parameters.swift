//
//  URL+Parameters.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

extension URL {
    func appendingQueryParameters(parameters: [String: String]) -> URL {
        guard let urlComponents = NSURLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        
        var mutableQueryItems: [NSURLQueryItem] = urlComponents.queryItems as [NSURLQueryItem]? ?? []
        
        mutableQueryItems.append(contentsOf: parameters.map { NSURLQueryItem(name: $0, value: $1) })
        
        urlComponents.queryItems = mutableQueryItems as [URLQueryItem]?
        
        return urlComponents.url!
    }
}
