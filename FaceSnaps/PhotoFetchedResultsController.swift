//
//  PhotoFetchedResultsController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/8/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreData

// Convenience class used to encapsulate error handling logic in it's own subclass
class PhotoFetchedResultsController: NSFetchedResultsController<NSManagedObject>, NSFetchedResultsControllerDelegate {
    
    private let collectionView: UICollectionView
    
    init(fetchRequest: NSFetchRequest<NSManagedObject>, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        executeFetch()
    }
    
    func executeFetch() {
        do {
          try performFetch()
        } catch let error as NSError {
            // TODO: Handle error
            print("Unresolved error: \(error), \(error.userInfo)")
        }
    }
    
    func performFetch(withPredicate predicate: NSPredicate?) {
        // Delete all the caches (currently none)
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        // Modify predicate on fetch Request
        fetchRequest.predicate = predicate
        // Get the new data
        executeFetch()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    // Informed that content has changed
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}





















