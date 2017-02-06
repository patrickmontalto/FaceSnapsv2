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
    
    lazy var refreshIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    var data: [FeedItem]!

    var loading = false
    let spinToken = "spinner"
    var page = 1
    
    
    lazy var collectionView: IGListCollectionView = {
        // TODO: Why are there spaces between sections?
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero

        let cv = IGListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        data = Array(FaceSnapsDataSource.sharedInstance.latestFeed)
    
        collectionView.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        // Add notification to scroll view to top when home is tapped
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: .tappedHomeNotificationName, object: nil)
        
        configureRefreshControl()
        
        // Make camera outline image
        let cameraImage = UIImage(named: "camera")!
        let cameraItem = UIBarButtonItem(image: cameraImage, style: .plain, target: #selector(launchCamera), action: nil)
        self.navigationItem.setLeftBarButton(cameraItem, animated: false)
        
        initializeFeed()
        
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        refreshControl.addSubview(refreshIndicator)
    }
    
    func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.backgroundView?.layer.zPosition = -1
        edgesForExtendedLayout = []
        
        view.addSubview(initLoadFeedIndicator)
        
        NSLayoutConstraint.activate([
                initLoadFeedIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                initLoadFeedIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
                refreshIndicator.centerYAnchor.constraint(equalTo: refreshControl.centerYAnchor),
                refreshIndicator.centerXAnchor.constraint(equalTo: refreshControl.centerXAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func launchCamera() {
    }
    
    private func initializeFeed() {
        // Check to see if data from last feed exists
        // If it does, display last feed and only refresh data
        if data.count > 0 {
            // Start refresh control
            let offset = CGPoint(x: 0, y: -refreshControl.frame.size.height)
            
            collectionView.setContentOffset(offset, animated: true)
            refreshControl.beginRefreshing()
            
            // TODO: Have to add an activity indicator to the refreshControl
            refreshControl.sendActions(for: .valueChanged)
            refreshIndicator.startAnimating()
        } else {
            getNewFeed()
        }
        
    }
    
    private func getNewFeed() {
        // Start animating
        initLoadFeedIndicator.startAnimating()
        
        FaceSnapsClient.sharedInstance.getUserFeed(atPage: 1) { (success, newData, errors) in
            DispatchQueue.main.async {
                // Stop animating
                self.initLoadFeedIndicator.stopAnimating()
                
                if success {
                    print("Got user feed!")
                    self.data = Array(newData!)
                    self.adapter.performUpdates(animated: true, completion: { (completed) in
                        // TODO: Save to realm and delete old feed
                        _ = FaceSnapsDataSource.sharedInstance.setLatestFeed(asFeed: newData!)
                        print("completed reload")
                        print(self.data)
                    })
                } else {
                    print("Couldn't get feed")
                }
                
            }
        }

    }
    
    
    func loadNextPage(completionHandler: @escaping (_ success: Bool, _ data: List<FeedItem>?) -> Void ) {
        let nextPage = page + 1
        FaceSnapsClient.sharedInstance.getUserFeed(atPage: nextPage) { (success, data, errors) in
            // Stop animating
            self.initLoadFeedIndicator.stopAnimating()
            
            if let data = data, data.count != 0 {
                print("Got next page at: \(self.page + 1)")
                completionHandler(true, data)
                self.page = nextPage
            } else {
                completionHandler(false, data)
            }
        }
    }
    
    func refreshData(sender: UIRefreshControl) {
        
        let lastFeedPostKeys = FaceSnapsDataSource.sharedInstance.postKeys
        let firstLoadedKey = data.last?.pk

        FaceSnapsClient.sharedInstance.getUserFeed(atPage: 1) { (success, newData, errors) in
            DispatchQueue.main.async {

                // Do not do anything if there is not any data
                guard let newData = newData else {
                    return
                }
                let lastPublicKeys = self.data.map { $0.pk }

                let newFeedItems = newData.filter({ (item) -> Bool in
                    return !lastPublicKeys.contains(item.pk)
                })
                
                var deletedFeedItems = [FeedItem]()
                
                if let firstLoadedKey = firstLoadedKey, let lastFeedPostKeys = lastFeedPostKeys {
                    // Get a list of deleted post keys
                    var deletedFeedPostKeys = lastFeedPostKeys.filter({ (key) -> Bool in
                        return !FaceSnapsDataSource.sharedInstance.postKeys!.contains(key)
                    })
                    // Only concern ourselves with posts that should be loaded in the current data
                    deletedFeedPostKeys = deletedFeedPostKeys.filter({ (key) -> Bool in
                        return key >= firstLoadedKey
                    })
                    // Sort through current data. Deleted posts are those with a key inside of the deletedFeedPostKeys array
                    deletedFeedItems = self.data.filter({ (item) -> Bool in
                        return deletedFeedPostKeys.contains(item.pk)
                    })
                }
                
                // If there are any deleted items or new items, update the feed with the new data
                if newFeedItems.count > 0 || deletedFeedItems.count > 0 {
                    _ = FaceSnapsDataSource.sharedInstance.setLatestFeed(asFeed: newData)
                }
                
                // If there are new posts, append to data and save data to Realm
                if newFeedItems.count > 0 {
                    self.data.insert(contentsOf: newFeedItems, at: 0)
                }
                
                // Delete items from data if there are any
                if deletedFeedItems.count > 0 {
                    for item in deletedFeedItems {
                        if let index = self.data.index(of: item) {
                            self.data.remove(at: index)
                        }
                    }
                }
                
                self.adapter.performUpdates(animated: true, completion: { (completed) in
                    print("completed pull-to-fresh")
                    print(self.data)
                    self.refreshControl.endRefreshing()
                    self.refreshIndicator.stopAnimating()
                })
                
            }
        }
    }
    
}

// MARK: IGListAdapterDataSource

extension HomeController: IGListAdapterDataSource {
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var objects = data as [IGListDiffable]
        
        if loading && !initLoadFeedIndicator.isAnimating {
            objects.append(spinToken as IGListDiffable)
        }
    
        return objects
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else {
            return FeedItemSectionController()
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}

// MARK: UIScrollViewDelegate
extension HomeController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 200 && !initLoadFeedIndicator.isAnimating {
            loading = true
            adapter.performUpdates(animated: true, completion: nil)
            DispatchQueue.global(qos: .default).async {
                // Load API data
                self.loadNextPage(completionHandler: { (success, data) in
                    // When complete:
                    DispatchQueue.main.async {
                        self.loading = false
                        
                        if let newData = data {
                            self.data.append(contentsOf: newData)
                            self.adapter.performUpdates(animated: true, completion: nil)
                        }
                    }
                    
                })
            }
        }
    }
}
