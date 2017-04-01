//
//  LocationSearchManager.swift
//  FaceSnaps
//
//  Created by Patrick on 3/24/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreLocation

/// This class is responsible for building the query for getting location data and managing dependent views.
class LocationSearchManager: NSObject, UISearchBarDelegate {
    
    // MARK: - Properties
    fileprivate var emptyTableText: String?
    
    weak var picker: LocationPickerController?
    
    fileprivate var searchBar: UISearchBar!
    
    fileprivate var tableView: UITableView!
    
    fileprivate var locations = [FourSquareLocation]()
    
    fileprivate var locationSearcher: LocationSearcher!
    
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
        self.locationSearcher = LocationSearcher()
        
        subscribeToLocationNotifications()
    }
    
    // MARK: - Actions
    func getLocationsForQuery(query: String) {
        
        // Start loading animation on picker
        picker?.animateLoading(true)
        
        // Clear array of data
        self.locations.removeAll()
        
        locationSearcher.getLocationsForQuery(query: query) { (result) in
            if let locations = result.0 {
                self.locations = locations
            } else if let locationError = result.1 {
                self.emptyTableText = locationError.cellText
            } else {
                return
            }
            
            self.picker?.animateLoading(false)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    deinit {
        unsubscribeToLocationNotifications()
    }
    
    // MARK: - Notifications
    private func subscribeToLocationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate), name: .locationManagerDidUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidFail), name: .locationManagerDidFailNotification, object: nil)
    }
    
    private func unsubscribeToLocationNotifications() {
        NotificationCenter.default.removeObserver(self, name: .locationManagerDidUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .locationManagerDidFailNotification, object: nil)
    }
    
    @objc private func locationDidUpdate() {
        getLocationsForQuery(query: searchBar.text ?? "")
    }
    
    @objc private func locationDidFail() {
        emptyTableText = LocationError.unlocatable.cellText
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


