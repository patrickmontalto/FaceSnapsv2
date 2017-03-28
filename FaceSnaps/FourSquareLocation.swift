//
//  FourSquareLocation.swift
//  FaceSnaps
//
//  Created by Patrick on 3/28/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

struct FourSquareLocation {
    enum Key {
        static let id = "id"
        static let lat = "lat"
        static let lng = "lng"
        static let name = "name"
    }
    var venueId: String
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String?
    var city: String?
    
    var detailString: String {
        if let address = address {
            if let city = city {
                return "\(address), \(city)"
            }
            return address
        }
        return ""
    }
    
    var parameterized: [String: Any] {
        return [Key.id: venueId, Key.lat: latitude, Key.lng: longitude, Key.name: name]
    }
}
