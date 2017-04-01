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
    
    var locationSearchManager: LocationSearchManager!
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = .white
        sb.placeholder = "Find a location"
        return sb
    }()
    
    lazy var locationsTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var location: CLLocation?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var refreshBtn: UIButton = {
        let refreshBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        let locationIcon = UIImage(named: "location_icon")!
        refreshBtn.setImage(locationIcon, for: .normal)
        refreshBtn.addTarget(self, action: #selector(self.handleRefreshBtn(sender:)), for: .touchUpInside)
        return refreshBtn
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Initializer
    convenience init(delegate: LocationPickerDelegate) {
        self.init()
        self.delegate = delegate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationSearchManager = LocationSearchManager(searchBar: self.searchBar, tableView: self.locationsTableView, picker: self)

        // Left item: Arrow/location indicator button
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: refreshBtn)
        refreshBtn.addSubview(activityIndicator)
        
        view.addSubview(searchBar)
        view.addSubview(locationsTableView)

        // Title: Locations
        title = "Locations"
        // Right item: Cancel (black button)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissPicker))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            locationsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            locationsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            locationsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            locationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func handleRefreshBtn(sender: UIButton) {
        locationSearchManager.refreshUserLocation()
    }
    
    func animateLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            if loading {
                self.refreshBtn.imageView?.isHidden = true
                self.refreshBtn.isEnabled = false
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.refreshBtn.imageView?.isHidden = false
                self.refreshBtn.isEnabled = true
            }
        }
    }
    
    // Cancel button tapped or location selected
    func dismissPicker() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Inform delegate that location was selected
    func selectLocation(location: FourSquareLocation) {
        delegate.locationPicker(self, didSelectLocation: location)
    }
    
}


