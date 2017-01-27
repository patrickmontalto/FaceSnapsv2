//
//  ControlsCellDelegate.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/25/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

enum FeedItemButtonType {
    case Like
    case Comment
    case LikesCount
}

protocol FeedItemSectionDelegate {
    func didPress(button: FeedItemButtonType)
}
