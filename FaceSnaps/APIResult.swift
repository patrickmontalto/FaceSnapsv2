//
//  APIResult.swift
//  FaceSnaps
//
//  Created by Patrick on 2/23/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

// TODO: Implement APIResult enum in network client
enum APIResult<Element> {
    case success(Element)
    case failure(APIError)
}
