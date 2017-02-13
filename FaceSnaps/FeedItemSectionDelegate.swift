//
//  ControlsCellDelegate.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/25/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

enum FeedItemButtonType {
    case like
    case comment
    case likesCount
    case authorName
}

protocol FeedItemSectionDelegate {
    func didPressLikeButton(forPost post: FeedItem, inSectionController sectionController: FeedItemSectionController, withButton button: UIButton)
    
    func didPressUserButton(forUser user: User)
    
    func didPressCommentButton(forPost post: FeedItem)
    
    func didPressLikesCount(forPost post: FeedItem)
}
