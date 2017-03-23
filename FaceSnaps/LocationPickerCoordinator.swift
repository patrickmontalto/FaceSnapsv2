//
//  LocationPickerCoordinator.swift
//  FaceSnaps
//
//  Created by Patrick on 3/23/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

class LocationPickerCoordinator: UINavigationController {
    var picker: LocationPickerController!
    var locationPickerDelegate: LocationPickerDelegate!
    
    convenience init(locationPickerDelegate: LocationPickerDelegate) {
        self.init()
        self.locationPickerDelegate = locationPickerDelegate
        picker = LocationPickerController(delegate: locationPickerDelegate)

        setViewControllers([picker], animated: true)
    }
}
