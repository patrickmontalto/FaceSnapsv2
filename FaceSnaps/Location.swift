//
//  Location.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/6/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Location: Object, MKAnnotation {
    
    dynamic var pk: Int = 0
    dynamic var venueId: String = ""
    dynamic var name: String = ""
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    // TODO: Inverse relationship for posts?
    
    convenience init(pk: Int, venueId: String, name: String, latitude: Double, longitude: Double) {
        self.init()
        
        self.pk = pk
        self.venueId = venueId
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(pk: Int, fourSquareLocation: FourSquareLocation) {
        self.init()
        self.pk = pk
        
        self.venueId = fourSquareLocation.venueId
        self.name = fourSquareLocation.name
        self.latitude = fourSquareLocation.latitude
        self.longitude = fourSquareLocation.longitude
        
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}
