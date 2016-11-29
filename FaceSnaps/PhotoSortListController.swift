//
//  PhotoSortListController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/8/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreData

class PhotoSortListController<SortType: CustomTitleConvertible>: UITableViewController where SortType: NSManagedObject {

    let dataSource: SortableDataSource<SortType>
    let sortItemSelector: SortItemSelector<SortType>
    
    var onSortSelection: ((Set<SortType>) -> Void)?
    
    init(dataSource: SortableDataSource<SortType>, sortItemSelector: SortItemSelector<SortType>) {
        self.dataSource = dataSource
        self.sortItemSelector = sortItemSelector
        super.init(style: .grouped)
        
        tableView.dataSource = dataSource
        tableView.delegate = sortItemSelector
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    func setupNavigation() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PhotoSortListController.dismissPhotoSortListController))
        
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func dismissPhotoSortListController() {
        // Set or clear selected Locations or Tags
        if dataSource.sortableItemType == .Tag {
            // When dismissed, if checkedItems is empty, set selectedTags to nil
            if sortItemSelector.checkedItems.isEmpty {
                UserDefaults.standard.set(nil, forKey: "selectedTags")
            } else {
                let selectedIdsURLs = sortItemSelector.checkedItems.map { $0.objectID.uriRepresentation() }
                let selectedIdsStrings = selectedIdsURLs.map { $0.absoluteString }
                UserDefaults.standard.set(selectedIdsStrings, forKey: "selectedTags")
            }
        } else {
            if sortItemSelector.checkedItems.isEmpty {
                UserDefaults.standard.set(nil, forKey: "selectedLocations")
            } else {
                let selectedLocations = sortItemSelector.checkedItems.map { $0.title }
                UserDefaults.standard.set(selectedLocations, forKey: "selectedLocations")
            }
        }
        
        
        // When dismissed, call the closure set to onSortSelection
        guard let onSortSelection = onSortSelection else {
            return
        }
        onSortSelection(sortItemSelector.checkedItems)
        dismiss(animated: true, completion: nil)
    }

}

















