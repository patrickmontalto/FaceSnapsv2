//
//  HomeController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 11/29/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit
import RealmSwift

class HomeController: UIViewController {
    
    lazy var initLoadFeedIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    var data: [FeedItem] {
        get {
            guard let latestFeed = FaceSnapsDataSource.sharedInstance.latestFeed else { return [] }
            return Array(latestFeed)
        }
    }
    
    lazy var collectionView: IGListCollectionView = {
        // TODO: Why are there spaces between sections?
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        let cv = IGListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFeed()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        // Make camera outline image
        let cameraImage = UIImage(named: "camera")!
        let cameraItem = UIBarButtonItem(image: cameraImage, style: .plain, target: #selector(launchCamera), action: nil)
        self.navigationItem.setLeftBarButton(cameraItem, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(initLoadFeedIndicator)
        
        NSLayoutConstraint.activate([
                initLoadFeedIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                initLoadFeedIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func launchCamera() {
    }
    
    private func initializeFeed() {
        // Start animating
        initLoadFeedIndicator.startAnimating()
        
        FaceSnapsClient.sharedInstance.getUserFeed { (success, errors) in
            // Stop animating
            self.initLoadFeedIndicator.stopAnimating()
            
            if success {
                print("Got user feed!")
                self.adapter.reloadData(completion: { (completed) in
                    print("completed reload")
                    print(self.data)
                })
            } else {
                print("Couldn't get feed")
            }
        }
    }
}

// MARK: IGListAdapterDataSource

extension HomeController: IGListAdapterDataSource {
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return FeedItemSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}

// MARK: IGListCollectionViewFlowLayout
extension HomeController {
    
}
