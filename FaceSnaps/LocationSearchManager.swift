//
//  LocationSearchManager.swift
//  FaceSnaps
//
//  Created by Patrick on 3/24/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreLocation

/// This class is responsible for building the query for getting location data and returning it.
class LocationSearchManager: NSObject, UISearchBarDelegate {
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
    
    var searchBar: UISearchBar!
    
    var locationManager: LocationManager!
    
    var tableView: UITableView!
    
    var locations = [FourSquareLocation]()
    
    var coordinate: CLLocationCoordinate2D?
    
    // MARK: - Initializers
    convenience init(searchBar: UISearchBar, tableView: UITableView, picker: LocationPickerController) {
        self.init()
        self.searchBar = searchBar
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
    func getLocationsForQuery(query: String) {
        
        // Check authorization status
        guard locationManager.authorized else {
            // TODO: Dismiss picker with error message?
            print("Not authorized for location services.")
            emptyTableText = LocationError.unauthorized.cellText
            return
        }
        
        // Check if coordinate was gotten
        guard let coordinate = coordinate else {
            getUserLocation()
            return
        }
        
        // Start loading animation on picker
        picker?.animateLoading(true)
        
        // Clear array of data
        self.locations.removeAll()
        
        FaceSnapsClient.sharedInstance.getLocations(query: query, coordinate: coordinate) { (locations, error) in
            if let error = error {
                _ = APIErrorHandler.handle(error: error, logError: true)
            }
            if let locations = locations {
                self.locations = locations
            } else {
                self.emptyTableText = LocationError.emptyResults.cellText
            }
            
            self.picker?.animateLoading(false)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func getUserLocation() {
        locationManager.getLocation()
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Make API call to get the results of the location search
        getLocationsForQuery(query: searchText)
    }
}
// MARK: - UITableViewDataSource & UITableViewDelegate
extension LocationSearchManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(self.locations.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        cell.textLabel?.textColor = .black
        
        if locations.count == 0 {
            cell.textLabel?.text = emptyTableText
        } else {
            
            // Set visual properties of cell text labels
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
            cell.detailTextLabel?.textColor = .gray
            
            // Get location
            let location = self.locations[indexPath.row]
            // Set text
            cell.textLabel?.text = location.name
            // TODO: get location details?
            //        cell.detailTextLabel?.text =
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.locations.count > 0 { return indexPath }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard locations.count > 0 else { return }
        let location = self.locations[indexPath.row]
        picker?.selectLocation(location: location)
        tableView.deselectRow(at: indexPath, animated: true)
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
        getLocationsForQuery(query: searchBar.text ?? "")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Failed with error. Update tableView cell to say "Couldn't locate your position"
        self.emptyTableText = LocationError.unlocatable.cellText
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            getUserLocation()
        }
    }
}

