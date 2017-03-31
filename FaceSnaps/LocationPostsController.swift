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
        cv.register(LocationMapView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LocationMapView.reuseId)
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        cv.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
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
        self.title = location.name

        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Get posts for location
        FaceSnapsClient.sharedInstance.getPosts(forLocation: location) { (data, error) in
            if let data = data {
                self.posts = Array(data)
                self.collectionView.reloadData()
            } else {
                _ = APIErrorHandler.handle(error: error!, logError: true)
            }
        }

        
    }
    
    // MARK: - Actions
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension LocationPostsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 0 }
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
        if indexPath.section == 0 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LocationMapView.reuseId, for: indexPath) as! LocationMapView
            
            view.location = self.location
            
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: 120, height: 18))
            label.text = "MOST RECENT"
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.textColor = .gray
            view.addSubview(label)
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 150)
        } else {
            return CGSize(width: view.frame.width, height: 40)
        }
    }
    

    
    // Present the individual post selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        let post = posts[indexPath.row]
        let vc = PostsCollectionViewContainer(style: .feed, dataSource: .postsForLocation(location: self.location, atRow: indexPath.row))
//        let vc = PostsCollectionViewContainer(style: .feed, dataSource: .individualPost(postId: post.pk))
        navigationController?.pushViewController(vc, animated: true)
    }

}
