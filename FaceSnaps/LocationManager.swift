//
//  LocationManager.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/3/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreLocation

/// This class is responsible for managing a CLLocationManager and location permissions.
class LocationManager: NSObject {
    
    // Location manager delivers updates to a delegate
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var onLocationFix: ((CLPlacemark?, Error?) -> Void)?
    
    convenience init(delegate: CLLocationManagerDelegate) {
        self.init()
        manager.delegate = delegate
        
        getPermission()
    }
    
    var authorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    func getLocation() {
        if authorized {
            manager.requestLocation()
        }
    }
    
    private func getPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}

