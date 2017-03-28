//
//  Location.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/6/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import RealmSwift
//import CoreData
//import CoreLocation

struct FourSquareLocation {
    var venueId: String
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String?
    var city: String?
    
    var detailString: String {
        if let address = address {
            if let city = city {
                return "\(address), \(city)"
            }
            return address
        }
        return ""
    }
}


class Location: Object {
    
    dynamic var pk: Int = 0
    dynamic var venueId: String = ""
    dynamic var name: String = ""
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    // TODO: Inverse relationship for posts?
    
    convenience init(pk: Int, venueId: String, name: String, latitude: Double, longitude: Double) {
        self.init()
        
        self.pk = pk
        self.venueId = venueId
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(pk: Int, fourSquareLocation: FourSquareLocation) {
        self.init()
        self.pk = pk
        
        self.venueId = fourSquareLocation.venueId
        self.name = fourSquareLocation.name
        self.latitude = fourSquareLocation.latitude
        self.longitude = fourSquareLocation.longitude
        
    }
    
    // MARK: - IGListDiffable
    
//    func diffIdentifier() -> NSObjectProtocol {
//        return pk as NSObjectProtocol
//    }
//
//    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
//        guard self !== object else { return true }
//        guard let object = object as? Comment else { return false }
//        return author!.isEqual(toDiffableObject: object.author)
//    }
    
    
}


//class Location: NSManagedObject {
//    static let entityName = "\(Location.self)"
//    
//    static var allLocationsRequest: NSFetchRequest<NSManagedObject> = {
//        let request = NSFetchRequest<NSManagedObject>(entityName: Location.entityName)
//        request.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
//        return request
//    }()
//        
//    private func getCityAndState(latitude: Double, longitude: Double, completionHandler: @escaping ((String) -> Void)) {
//
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//
//        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
//            guard let placemark = placemarks?.first, let city = placemark.locality, let state = placemark.administrativeArea else {
//                // TODO: User does not know when it fails
//                print("Error getting reverse geocoding: \(error)")
//                completionHandler("")
//                return
//            }
//
//            completionHandler("\(city), \(state)")
//        }
//    }
//    
//    class func uniqueLocations(locations: [CustomTitleConvertible]) -> [CustomTitleConvertible] {
//        return locations.filterDuplicates { $0.title == $1.title }
//    }
//        
//    class func location(withLatitude latitude: Double, longitude: Double) -> Location {
//        let location = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Location
//        
//        // Set temporary title
//        location.title = ""
//        // Set title async
//        location.getCityAndState(latitude: latitude, longitude: longitude) { (locationString) in
//            location.title = locationString
//            CoreDataController.sharedInstance.saveContext()
//        }
//        location.latitude = latitude
//        location.longitude = longitude
//        return location
//    }
//}

// MARK: - Properties

//extension Location {
//    @NSManaged var latitude: Double
//    @NSManaged var longitude: Double
//    @NSManaged var title: String
//    
//    
//    
//}
