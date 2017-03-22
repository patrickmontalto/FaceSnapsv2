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
    var locationSearchManager = LocationSearchManager.sharedInstance
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = .white
        sb.placeholder = "Find a location"
        return sb
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
        LocationManager().manager
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Constraints
        NSLayoutConstraint.activate([
            
        ])
    }
    
}
