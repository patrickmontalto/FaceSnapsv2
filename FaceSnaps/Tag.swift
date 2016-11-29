//
//  Tag.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/6/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {
    static let entityName = "\(Tag.self)"
    
    static var allTagsRequest: NSFetchRequest<NSManagedObject> = {
        let request = NSFetchRequest<NSManagedObject>(entityName: Tag.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }()
    
    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Tag

        tag.title = title
        
        return tag
    }
}

// MARK: - Properties
extension Tag {
    @NSManaged var title: String
}
