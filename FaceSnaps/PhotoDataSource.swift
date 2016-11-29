//
//  PhotoDataSource.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/8/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Use dependency injection to assign values to these properties when we create an instance
class PhotoDataSource: NSObject {
    let collectionView: UICollectionView
    let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    let fetchedResultsController: PhotoFetchedResultsController
    let photoDeletionManager: PhotoDeletionManager
    
    var editingModeEnabled: Bool
    
    init(fetchRequest: NSFetchRequest<NSManagedObject>, collectionView: UICollectionView, photoDeletionDelegate: PhotoDeletionManagerDelegate) {
        self.collectionView = collectionView
        self.fetchedResultsController = PhotoFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, collectionView: self.collectionView)
        self.photoDeletionManager = PhotoDeletionManager(collectionView: collectionView, delegate: photoDeletionDelegate)
        self.editingModeEnabled = false
        super.init()
    }
    
    // Use data source to interact with fetched results controller from photo list controller
    func performFetch(withPredicate predicate: NSPredicate?) {
        self.fetchedResultsController.performFetch(withPredicate: predicate)
        // Inform the collectionView to reload data (fetchedResultsController wouldn't know otherwise)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        
        let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        cell.imageView.image = photo.uiImage
        
        // For deletion, set tag as row
        cell.deleteButton.tag = indexPath.row
        // MARK: temporarily add target here
        cell.deleteButton.addTarget(photoDeletionManager, action: #selector(photoDeletionManager.deletePhoto(sender:)), for: .touchUpInside)
        // If editing mode is enabled, show delete button
        cell.deleteButton.isHidden = !editingModeEnabled
        
        return cell
    }
    
}































