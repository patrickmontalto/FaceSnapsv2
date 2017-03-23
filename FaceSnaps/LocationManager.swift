//
//  LocationManager.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/3/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreLocation

/// This class is responsible for building the query for getting location data and returning it.
class LocationSearchManager: NSObject, UISearchBarDelegate {
    // TODO: Query location with lat, lng, and query (name)
    // Need to get location from LocationManager
    
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
    
    var emptyTableText: String?
    
    weak var picker: LocationPickerController?
    
    var locationManager: LocationManager!
    
    var tableView: UITableView!
    
    var locations = [FourSquareLocation]()
    
    var coordinate: CLLocationCoordinate2D?

    // MARK: - Initializers
    convenience init(searchBar: UISearchBar, tableView: UITableView, picker: LocationPickerController) {
        self.init()
        searchBar.delegate = self
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        
        self.picker = picker
        
        // Init of locationManager will trigger requesting permission
        self.locationManager = LocationManager(delegate: self)
    }
    
    // MARK: - Methods
    func getLocationsForQuery(query: String, coordinate: CLLocationCoordinate2D, completionHandler: @escaping (([FourSquareLocation]?) -> Void)) {
        FaceSnapsClient.sharedInstance.getLocations(query: query, coordinate: coordinate) { (locations, error) in
            if let error = error {
                _ = APIErrorHandler.handle(error: error, logError: true)
            }
            completionHandler(locations)
        }
    }
    
    func getUserLocation() {
        locationManager.getLocation()
    }
    
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard locationManager.authorized else {
            // TODO: Dismiss picker with error message?
            print("Not authorized for location services.")
            emptyTableText = LocationError.unauthorized.cellText
        }
        
        guard let coordinate = coordinate else {
            getUserLocation()
        }
        
        // Start loading animation on picker
        picker?.animateLoading(true)
        
        // Clear array of data
        self.locations.removeAll()
        
        // Make API call to get the results of the location search
        getLocationsForQuery(query: searchText, coordinate: coordinate) { (locations) in
            guard let locations = locations else {
                // No locations for query and coordinate
                // One table view cell with "No results." as text
                self.emptyTableText = LocationError.emptyResults.cellText
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.locations = locations
            self.picker?.animateLoading(false)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
// MARK: - UITableViewDataSource & UITableViewDelegate
extension LocationSearchManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(self.locations.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // Set visual properties of cell text labels
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
        cell.detailTextLabel?.textColor = .gray
        
        // Get location
        let location = self.locations[indexPath.row]
        // Set text
        cell.textLabel?.text = location.name
        // TODO: get location details?
//        cell.detailTextLabel?.text =
        
        return cell
    }
}
// MARK: - CLLocationManagerDelegate
extension LocationSearchManager: CLLocationManagerDelegate {
    // Notified when the location update completes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grab the first location in array
        guard let location = locations.first else { return }
        // Update the coordinate property
        self.coordinate = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Failed with error. Update tableView cell to say "Couldn't locate your position"
        self.emptyTableText = LocationError.unlocatable.cellText
    }
}


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

