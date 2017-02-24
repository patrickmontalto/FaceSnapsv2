//
//  CollectionViewContainer.swift
//  FaceSnaps
//
//  Created by Patrick on 2/24/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

protocol CollectionViewContainer {
    var adapter: IGListAdapter { get set }
}
