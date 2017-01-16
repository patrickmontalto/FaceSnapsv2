//
//  LabelSectionController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

final class FeedItemSectionController: IGListSectionController, IGListSectionType, IGListSupplementaryViewSource {
    
    var feedItem: FeedItem!
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    // MARK: IGlistSectionType
    func numberOfItems() -> Int {
        return feedItem.comments.count
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: LabelCell.self, for: self, at: index) as! LabelCell
        cell.label.text = feedItem.comments[index]
        return cell
    }
    
    func didUpdate(to object: Any) {
        //feedItem = object as? FeedItem
    }
    
    func didSelectItem(at index: Int) {}
    
    // MARK: IGListSupplementaryViewSource
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                       for: self,
                                                                       nibName: "UserHeaderView",
                                                                       bundle: nil,
                                                                       at: index) as! UserHeaderView
        view.nameLabel.text = feedItem.user.name
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }
    
}
