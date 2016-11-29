//
//  PhotoDeletionManager.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/16/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PhotoDeletionManagerDelegate: class {
    func didTapDelete(atRow row: Int)
    
    func userLongPressInitiated(gestureRecognizer: UILongPressGestureRecognizer)
}

// Communicates to PhotoListController user actions taken to delete photo
class PhotoDeletionManager: NSObject, UIGestureRecognizerDelegate {
    
    private let collectionView: UICollectionView
    
    weak var delegate: PhotoDeletionManagerDelegate!
    
    init(collectionView: UICollectionView, delegate: PhotoDeletionManagerDelegate) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        self.enableLongPressDeletion()
    }
    
    // MARK: UIGestureRecognizerDelegate
    func enableLongPressDeletion() {
        let lpgr = UILongPressGestureRecognizer(target: delegate, action: #selector(delegate.userLongPressInitiated(gestureRecognizer:)))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func deletePhoto(sender: UIButton) {
        let row = sender.tag
        delegate?.didTapDelete(atRow: row)
    }
}

