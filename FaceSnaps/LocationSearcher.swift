//
//  LocationSearcher.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/31/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - LocationError
enum LocationError {
    case unlocatable, emptyResults, unauthorized
    
    var cellText: String {
        switch self {
        case .emptyResults:
            return "No locations found."
        case .unlocatable:
            return "Couldn't locate your position."
        case .unauthorized:
            return "Not authorized for location services."
        }
    }
}

/// The purpose of this class is to manage the results of a location query.
/// The query results can then be handed off to a controller to update a table view or collection view
/// as needed.
class LocationSearcher: NSObject {
    typealias LocationQueryResult = ([FourSquareLocation]?, LocationError?)
    typealias LocationHandler = ((LocationQueryResult) -> Void)
    
    // MARK: - Properties
    
    private var locationManager: LocationManager!

    fileprivate var coordinate: CLLocationCoordinate2D?
    
    // MARK: - Initializers
    override init() {
        super.init()
        self.locationManager = LocationManager(delegate: self)
    }
    
    // MARK: - Actions
    func getLocationsForQuery(query: String, completionHandler: @escaping LocationHandler) {
        // Check authorization status
        guard locationManager.authorized else {
            // TODO: Dismiss picker with error message?
            print("Not authorized for location services.")
            let result: LocationQueryResult = (nil, LocationError.unauthorized)
            completionHandler(result)
            return
        }
        
        // Check if coordinate was gotten
        guard let coordinate = coordinate else {
            getUserLocation()
            return
        }
    
        FaceSnapsClient.sharedInstance.getLocations(query: query, coordinate: coordinate) { (locations, error) in
            
            var result: LocationQueryResult
            
            if let locations = locations {
                // Did have locations
                result = (locations, nil)
            } else {
                // No locations, no error
                result = (nil, LocationError.emptyResults)
            }
            
            // Error
            if let error = error {
                _ = APIErrorHandler.handle(error: error, logError: true)
                result = (nil, LocationError.unlocatable)
            }
            
            completionHandler(result)
        }
    }
    
    func getUserLocation() {
        locationManager.getLocation()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationSearcher: CLLocationManagerDelegate {
    // Notified when the location update completes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grab the first location in array
        guard let location = locations.first else { return }
        // Update the coordinate property
        self.coordinate = location.coordinate
        // Post notification for updated location
        NotificationCenter.default.post(name: .locationManagerDidUpdateNotification, object: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Post notification for failed location attempt
        NotificationCenter.default.post(name: .locationManagerDidFailNotification, object: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            getUserLocation()
        }
    }
}
