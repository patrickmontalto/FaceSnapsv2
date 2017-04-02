//
//  TagPostsController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 4/1/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class TagPostsController: UIViewController {
    // MARK: - Properties
    fileprivate let tag: Tag
    fileprivate var posts = [FeedItem]()
    
    lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.minimumLineSpacing = 1
        cvLayout.minimumInteritemSpacing = 1
        let itemWidth = (self.view.frame.width - 2)/3
        cvLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        return cv
    }()
    // MARK: - Initializers
    init(tag: Tag) {
        self.tag = tag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "#\(tag.name)"
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Get posts for location
        FaceSnapsClient.sharedInstance.getPosts(forTag: tag) { (data, error) in
            if let data = data {
                self.posts = data
                self.collectionView.reloadData()
            } else {
                _ = APIErrorHandler.handle(error: error!, logError: true)
            }
        }
    }
    // MARK: - Actions
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TagPostsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 120, height: 18))
        label.text = "MOST RECENT"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .gray
        view.addSubview(label)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.width, height: 40)
    }
    
    // Present the individual post selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = PostsCollectionViewContainer(style: .feed, dataSource: .postsForTag(tag: self.tag, atRow: indexPath.row))
        navigationController?.pushViewController(vc, animated: true)
    }

}
