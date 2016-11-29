//
//  LocationManager.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/3/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    // Location manager delivers updates to a delegate
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var onLocationFix: ((CLPlacemark?, Error?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        
        getPermission()
    }
    
    private func getPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    // Responding to errors:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let userInfo = (error as NSError).userInfo
        print("Unresolved error \(error), \(userInfo)")
    }
    
    // Does get a location:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // Convert coordinate to user-friendly representation via CLGeocoder
        // Grab first placemark object and pass it through to the call site through a closure
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let onLocationFix = self.onLocationFix {
                onLocationFix(placemarks?.first, error)
            }
        }
    }
}































