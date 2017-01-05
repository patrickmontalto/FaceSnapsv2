//
//  APIClient.swift
//  FaceSnaps
//
//  Created by Patrick on 1/4/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

class APIClient {
    
    // MARK: - properties
    // TODO: is this class necessary with AlamoFire?
    
    static func buildURLString(scheme: String, host: String, port: NSNumber?, clientType: APIConstants.Client, endpoint: String) -> String {
        if let port = port {
            return "\(scheme)://\(host):\(port)\(endpoint)"
        } else {
            return "\(scheme)://\(host)\(endpoint)"
        }
    }
}
