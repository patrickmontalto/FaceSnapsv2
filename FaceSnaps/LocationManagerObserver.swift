//
//  LocationManagerObserver.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/31/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

typealias LocationManagerObserver = LocationManagerObservable & LocationManagerConfigurable

protocol LocationManagerObservable {
    func subscribeToLocationNotifications()
    func unsubscribeToLocationNotifications()
}

@objc protocol LocationManagerConfigurable: class {
    func locationDidUpdate()
    func locationDidFail()
}

extension LocationManagerObservable where Self: LocationManagerObserver {
    func subscribeToLocationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate), name: .locationManagerDidUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidFail), name: .locationManagerDidFailNotification, object: nil)
    }
    
    func unsubscribeToLocationNotifications() {
        NotificationCenter.default.removeObserver(self, name: .locationManagerDidUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .locationManagerDidFailNotification, object: nil)
    }
}
