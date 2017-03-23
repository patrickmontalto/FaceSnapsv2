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
        return LocationSearchManager(searchBar: self.searchBar, tableView: self.locationsTableView, picker: self)
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
        let refreshBtn = UIButton()
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        let locationIcon = UIImage(named: "location_icon")!
        refreshBtn.setImage(locationIcon, for: .normal)
        refreshBtn.addTarget(self, action: #selector(self.handleRefreshBtn(sender:)), for: .touchUpInside)
        return refreshBtn
    }()
    
    // MARK: - Initializer
    convenience init(delegate: LocationPickerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Navigation item:
        // Left item: Arrow/location indicator button
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: refreshBtn)
        // let btnWidth = refreshBtn.bounds.size.width
        // let halfButtonHeight = refreshBtn.bounds.size.height / 2
        refreshBtn.addSubview(activityIndicator)

        // Title: Locations
        title = "Locations"
        // Right item: Cancel (black button)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissPicker))
        // TODO: Get location
        
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
        // 
    }
    
    func animateLoading(_ loading: Bool) {
        if loading {
            refreshBtn.imageView?.isHidden = true
            refreshBtn.isEnabled = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            refreshBtn.imageView?.isHidden = false
            refreshBtn.isEnabled = true
        }
    }
    
    func dismissPicker() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


