//
//  LocationMapView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/31/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import MapKit

/// A mapView reusable view container for UICollectionView.
class LocationMapView: UICollectionReusableView {
    
    static let reuseId = String(describing: LocationMapView.self)
    
    // MARK: - Properties
    var location: Location! {
        didSet {
            setMapRegion()
            setMapPin()
        }
    }
    
    var mapView: MKMapView = {
        let view = MKMapView()
        view.isScrollEnabled = true
        view.isZoomEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    func didLoad() {
        // Set mapViewDelegate
        mapView.delegate = self
        
        // Add subviews
        addSubview(mapView)
        
        // Activate constraints
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // MARK: - Actions
    private func setMapRegion() {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000)
        mapView.region = region
    }
    
    private func setMapPin() {
        mapView.addAnnotation(location)
    }
}
// MARK: - MKMapViewDelegate
extension LocationMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Location {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        }
        return nil
    }
}
