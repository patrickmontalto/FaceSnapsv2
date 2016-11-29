//
//  Location.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/6/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Location: NSManagedObject {
    static let entityName = "\(Location.self)"
    
    static var allLocationsRequest: NSFetchRequest<NSManagedObject> = {
        let request = NSFetchRequest<NSManagedObject>(entityName: Location.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        return request
    }()
        
    private func getCityAndState(latitude: Double, longitude: Double, completionHandler: @escaping ((String) -> Void)) {

        let location = CLLocation(latitude: latitude, longitude: longitude)

        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first, let city = placemark.locality, let state = placemark.administrativeArea else {
                // TODO: User does not know when it fails
                print("Error getting reverse geocoding: \(error)")
                completionHandler("")
                return
            }

            completionHandler("\(city), \(state)")
        }
    }
    
    class func uniqueLocations(locations: [CustomTitleConvertible]) -> [CustomTitleConvertible] {
        return locations.filterDuplicates { $0.title == $1.title }
    }
        
    class func location(withLatitude latitude: Double, longitude: Double) -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Location
        
        // Set temporary title
        location.title = ""
        // Set title async
        location.getCityAndState(latitude: latitude, longitude: longitude) { (locationString) in
            location.title = locationString
            CoreDataController.sharedInstance.saveContext()
        }
        location.latitude = latitude
        location.longitude = longitude
        return location
    }
}

// MARK: - Properties
extension Location {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var title: String
    
}
