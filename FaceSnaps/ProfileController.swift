//
//  ProfileController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    var user: User!

    lazy var profileHeaderView: UIView = {
        return UIView()
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // TODO: profileHeaderView is a header to the entire collectionView
    // CollectionView will have 3 cells per row
}
