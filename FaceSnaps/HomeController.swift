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

protocol FeedItemReloadDelegate {
    func didUpdateFeedItem(feedItem: FeedItem)
}
extension FeedItemReloadDelegate where Self: CollectionViewContainer {
    func didUpdateFeedItem(feedItem: FeedItem) {
        adapter.reloadObjects([feedItem])
    }
}

class HomeController: UIViewController, CollectionViewContainer {
    
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
        
        // If there is a last feed, set data.
        if let lastFeedItems = FaceSnapsDataSource.sharedInstance.lastFeedItems {
            data = Array(lastFeedItems)
        } else {
            data = []
        }
    
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
        
        // Add notification to observe changes in the post
        observePostUpdateNotifications(responseSelector: #selector(updatePostInData(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Unhide FaceSnaps logo and tab bar
        (navigationController as? HomeNavigationController)?.logoIsHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        refreshControl.addSubview(refreshIndicator)
    }
    
    func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
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
    
    /// Updates the post if the post is currently loaded by the controller.
    /// Will not update the post if source of update was initiated by self.
    func updatePostInData(_ notification: Notification) {
        
        guard let notifier = notification.object as? UIViewController, notifier != self else {
            return
        }
        
        guard let userInfo = notification.userInfo else { return }
        
        // TODO: Skip update if source for notification was self??
        if let newPost = userInfo["post"] as? FeedItem {
            let newPostId = newPost.pk
            if let oldPost = data.first(where: {$0.pk == newPostId }) {
                oldPost.comments = newPost.comments
                oldPost.liked = newPost.liked
                oldPost.likesCount = newPost.likesCount
                self.adapter.reloadObjects([oldPost])
            }
        }
    }
    
    private func getNewFeed() {
        // Start animating
        initLoadFeedIndicator.startAnimating()
        
        FaceSnapsClient.sharedInstance.getUserFeed(atPage: 1) { (newData, error) in
            DispatchQueue.main.async {
                // Stop animating
                self.initLoadFeedIndicator.stopAnimating()
                
                if error == nil {
                    print("Got user feed!")
                    self.data = Array(newData!)
                    self.adapter.performUpdates(animated: true, completion: { (completed) in
                        // TODO: Save to realm and delete old feed
                        print("completed reload")
                    })
                } else {
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    APIErrorHandler.handle(error: error!, withActions: [action], presentingViewController: self)
                }
                
            }
        }

    }
    
    
    func loadNextPage(completionHandler: @escaping (_ success: Bool, _ data: List<FeedItem>?) -> Void ) {
        let nextPage = page + 1
        FaceSnapsClient.sharedInstance.getUserFeed(atPage: nextPage) { (data, error) in
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


        FaceSnapsClient.sharedInstance.getUserFeed(atPage: 1) { (newData, error) in
            DispatchQueue.main.async {

                // Do not do anything if there is not any data
                guard let newData = newData else {
                    return
                }
                
                self.data = Array(newData)
                self.adapter.reloadObjects(self.data!)
                self.adapter.performUpdates(animated: true, completion: { (completed) in
                    print("completed pull-to-fresh")
                    //print(self.data)
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
            return FeedItemSectionController(feedItemSectionDelegate: self, commentDelegate: self)
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}

// MARK: UIScrollViewDelegate
extension HomeController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContenopffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContenopffset.pointee.y + scrollView.bounds.height)
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

// TODO: Clean up delegates!!
// MARK: FeedItemSectionDelegate
extension HomeController: FeedItemSectionDelegate, CommentDelegate {

}

// MARK: - FeedItemReloadDelegate
extension HomeController: FeedItemReloadDelegate {}
