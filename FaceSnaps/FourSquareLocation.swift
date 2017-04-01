//
//  FourSquareLocation.swift
//  FaceSnaps
//
//  Created by Patrick on 3/28/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import MapKit
import Foundation

class FourSquareLocation: NSObject, MKAnnotation {
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
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    init(venueId: String, name: String, latitude: Double, longitude: Double, address: String?, city: String?) {
        self.venueId = venueId
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.city = city
    }
    
    init(location: Location) {
        self.venueId = location.venueId
        self.name = location.name
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.address = nil
        self.city = nil
    }
}

