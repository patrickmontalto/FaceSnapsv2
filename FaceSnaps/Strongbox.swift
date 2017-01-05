//
//  Strongbox.swift
//  FaceSnaps
//
//  Created by Patrick on 1/5/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import Security
import Strongbox

class FaceSnapsStrongbox {
    static let sharedInstance: Strongbox = Strongbox()
    
    private init() {}
}
