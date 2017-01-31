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

    lazy var data: [FeedItem] = Array(FaceSnapsDataSource.sharedInstance.latestFeed!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFeed()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        // Add notification to scroll view to top when home is tapped
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: .tappedHomeNotificationName, object: nil)
        
        // Make camera outline image
        let cameraImage = UIImage(named: "camera")!
        let cameraItem = UIBarButtonItem(image: cameraImage, style: .plain, target: #selector(launchCamera), action: nil)
        self.navigationItem.setLeftBarButton(cameraItem, animated: false)
        
    }
    
    func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
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
        
        FaceSnapsClient.sharedInstance.getUserFeed(atPage: 0) { (success, data, errors) in
            DispatchQueue.main.async {
                // Stop animating
                self.initLoadFeedIndicator.stopAnimating()
                
                if success {
                    print("Got user feed!")
                    self.data = Array(FaceSnapsDataSource.sharedInstance.latestFeed!)
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
    
    func loadNextPage(completionHandler: @escaping (_ success: Bool, _ data: [FeedItem]?) -> Void ) {
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
