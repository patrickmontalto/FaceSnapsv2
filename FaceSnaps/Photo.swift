//
//  Photo.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/6/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

class Photo: NSManagedObject {
    static let entityName = "\(Photo.self)"
    
    static var allPhotosRequest: NSFetchRequest<NSManagedObject> = {
        let request = NSFetchRequest<NSManagedObject>(entityName: Photo.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        return request
    }()
    
    class func photo(withImage image: UIImage) -> Photo {
        let photo = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Photo
        
        photo.date = Date().timeIntervalSince1970
        photo.image = UIImageJPEGRepresentation(image, 1.0)!
        
        return photo
    }
    
    class func photo(withImage image: UIImage, tags: [String], location: CLLocation?) -> Photo {
        let photo = Photo.photo(withImage: image)
        photo.addTags(tags: tags)
        photo.addLocation(location: location)
        
        return photo
    }
    
    // Add one tag
    func addTag(withTitle title: String) {
        let tag = Tag.tag(withTitle: title)
        tags.insert(tag)
    }
    
    // Add an array of tags
    func addTags(tags: [String]) {
        for tag in tags {
            addTag(withTitle: tag)
        }
    }
    
    // Add location
    func addLocation(location: CLLocation?) {
        if let location = location {
            let photoLocation = Location.location(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.location = photoLocation
        }
    }
}

// MARK: - Properties
extension Photo {
    @NSManaged var date: TimeInterval
    @NSManaged var image: Data
    @NSManaged var tags: Set<Tag> // Order doesn't matter & will be unique
    @NSManaged var location: Location?
    
    var uiImage: UIImage {
        // Might as well crash here if the data is incapable of being a UIImage
        return UIImage(data: self.image)!
    }
}


















