//
//  SortableDataSource.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/8/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CustomTitleConvertible {
    var title: String { get }
}

extension Tag: CustomTitleConvertible {}

extension Location: CustomTitleConvertible {}

// Enum for switching on
enum SortableItemType {
    case Tag, Location
}

// This data source is responsible for populating PhotoSortListController's UITableView
class SortableDataSource<SortType: CustomTitleConvertible>: NSObject, UITableViewDataSource where SortType: NSManagedObject {
    
    let fetchedResultsController: NSFetchedResultsController<NSManagedObject>
    
    var results: [SortType]? {
        if sortableItemType == .Location {
            let locations = fetchedResultsController.fetchedObjects as! [Location]
            let filteredLocations = Location.uniqueLocations(locations: locations)
            
            return filteredLocations as? [SortType]
        }
        return fetchedResultsController.fetchedObjects as? [SortType]
    }
    
    // Selected locations are only their string representations, not actual objects in Core Data
    var selectedLocations: [String]? {
        return UserDefaults.standard.array(forKey: "selectedLocations") as? [String]
    }
    
    var selectedTags: [NSManagedObjectID]? {
        guard let selectedIdsStrings = UserDefaults.standard.array(forKey: "selectedTags") as? [String] else {
            return nil
        }
        let selectedIdsUrls = selectedIdsStrings.map { URL(string: $0)! }
        let selectedIds = selectedIdsUrls.map {(CoreDataController.sharedInstance.persistentStoreCoordinator.managedObjectID(forURIRepresentation: $0)!) }
        return selectedIds
    }
    
    // TODO: Should this be optional?
    var sortableItemType: SortableItemType {
        if (SortType.self as NSObject.Type) is Tag.Type {
            return .Tag
        } else {
            return .Location
        }
    }
    
    init(fetchRequest: NSFetchRequest<NSManagedObject>, managedObjectContext moc: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unresolved error: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return results?.count ?? 0
            default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "sortableItemCell")
        cell.selectionStyle = .none
        
        // Read from User Defaults for last selected tags array.
        // If there are any selected Tags, section 0, row 0 will be unchecked
        
        configureCellForSortType(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCellForSortType(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        // Read from User Defaults for last selected tags/locations array.
        // If there are any selected Locations/Tags, section 0, row 0 will be unchecked
        
        // Switch on type to determine which collection to be checking for
        let selectedItems: [Any]? = {
            switch sortableItemType {
            case .Tag:
                return selectedTags
            case .Location:
                return selectedLocations
            }
        }()
        
        switch (indexPath.section, indexPath.row) {
        case (0,0) :
            // If any selected tags/locations loaded, this will be unchecked
            cell.textLabel?.text = "All \(SortType.self)s"
            if selectedItems == nil {
                cell.accessoryType = .checkmark
            }
        case (1,_):
            
            guard let sortItem = results?[indexPath.row] else {
                break
            }
        
            // TODO: Refactor this. Can it be used for two filters at once?
            if sortableItemType == .Tag {
                if let selectedTags = selectedTags {
                    if selectedTags.contains(sortItem.objectID) {
                        cell.accessoryType = .checkmark
                    }
                }
            } else {
                if let selectedLocations = selectedLocations {
                    if selectedLocations.contains(sortItem.title) {
                        cell.accessoryType = .checkmark
                    }
                }
            }
                        
            cell.textLabel?.text = sortItem.title
        default: break
        }
        
    }
    
}

























