//
//  SortItemSelector.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/8/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SortItemSelector<SortType: NSManagedObject>: NSObject, UITableViewDelegate {
    
    // Create set of tags/locations
    fileprivate let sortItems: [SortType]
    var checkedItems: Set<SortType> = []
    
    init(sortItems: [SortType]) {
        self.sortItems = sortItems
        super.init()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                
                let nextSection = indexPath.section.advanced(by: 1)
                
                let numberOfRowsInSubsequentSection = tableView.numberOfRows(inSection: nextSection)
                
                for row in 0..<numberOfRowsInSubsequentSection {
                    let indexPath = NSIndexPath(row: row, section: nextSection)
                    
                    let cell = tableView.cellForRow(at: indexPath as IndexPath)
                    cell?.accessoryType = .none
                    
                    checkedItems = []
                }
            }
            
        case 1:
            let allItemsIndexPath = NSIndexPath(row: 0, section: 0)
            let allItemsCell = tableView.cellForRow(at: allItemsIndexPath as IndexPath)
            allItemsCell?.accessoryType = .none
            
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            let item = sortItems[indexPath.row]

            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                checkedItems.insert(item)
            } else if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checkedItems.remove(item)
            }
            
        default: break
        }
        
        print(checkedItems.description)
    }
}




































