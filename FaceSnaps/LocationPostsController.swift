//
//  LocationPostsController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/31/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

/// A View Controller containing a map with the pinned location,
/// as well as the posts for that particular location.

class LocationPostsController: UIViewController {
    
    // MARK: - Properties
    fileprivate let location: Location
    fileprivate var posts = [FeedItem]()
    
    lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.minimumLineSpacing = 1
        cvLayout.minimumInteritemSpacing = 1
        let itemWidth = (self.view.frame.width - 2)/3
        cvLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cvLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 150)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()

    
    // MARK: - Initializers
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
        
    }
    
    // MARK: - Actions
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension LocationPostsController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        if let photo = post.photo {
            cell.setImage(image: photo)
        } else {
            cell.setImage(image: UIImage())
            let caching = true
            // Begin background process to download image from URL
            // Cache if necessary
            FaceSnapsDataSource.sharedInstance.photoFromURL(for: post, cache: caching, completionHandler: { (image) in
                DispatchQueue.main.async {
                    cell.setImage(image: image)
                }
            })
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "locationMapView", for: indexPath) as! LocationMapView
        
        cell.frame.size.height = 150
        
        return cell
    }
    
    // Present the individual post selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let vc = PostsCollectionViewContainer(style: .feed, dataSource: .individualPost(postId: post.pk))
        navigationController?.pushViewController(vc, animated: true)
    }

}
