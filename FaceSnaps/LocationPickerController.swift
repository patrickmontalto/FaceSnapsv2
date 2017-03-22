//
//  LocationPickerController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/21/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol LocationPickerDelegate {
    func locationPicker(_ picker: LocationPickerController, didSelectLocation location: FourSquareLocation)
}

class LocationPickerController: UIViewController {
    
    // MARK: - Properties
    var delegate: LocationPickerDelegate!
    lazy var locationSearchManager: LocationSearchManager = {
        return LocationSearchManager(searchBar: self.searchBar, tableView: self.locationsTableView, presentingViewController: self)
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = .white
        sb.placeholder = "Find a location"
        return sb
    }()
    
    lazy var locationsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var location: CLLocation?
    
    // MARK: - Initializer
    convenience init(delegate: LocationPickerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Navigation item:
        // Left item: Arrow/location indicator button
            // Press to refresh location
        // Title: Locations
        // Right item: Cancel (black button)
        // TODO: Get location
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Constraints
        NSLayoutConstraint.activate([
            
        ])
    }
    
    func animateLoading(_ loading: Bool) {
        
    }
    
    
}


