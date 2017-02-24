//
//  PostsCollectionViewContainer.swift
//  FaceSnaps
//
//  Created by Patrick on 2/24/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

enum PostsCollectionViewContainerStyle {
    case thumbnails, feed
}

enum PostsCollectionViewDataSourceType {
    case postsLiked
    case postsForTag(tag: String)
    case postsForGeotag(geotag: String)
    case individualPost(postId: Int)
}

class PostsCollectionViewContainer: UIViewController, CollectionViewContainer {
    
    var data = [FeedItem]()
    var page = 0
    var loading = false
    let spinToken = "spinner"
    
//    lazy var initLoadFeedIndicator: UIActivityIndicatorView = {
//        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        view.hidesWhenStopped = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    var dataSourceType: PostsCollectionViewDataSourceType!
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    lazy var collectionView: IGListCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        let cv = IGListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    

    init(style: PostsCollectionViewContainerStyle, dataSource: PostsCollectionViewDataSourceType) {
        super.init(nibName: nil, bundle: nil)
        self.dataSourceType = dataSource
        
        // Default style is feed. If thumbnails, change flow layout for collectionView
        if style == .thumbnails {
            let cvLayout = UICollectionViewFlowLayout()
            cvLayout.minimumLineSpacing = 1
            cvLayout.minimumInteritemSpacing = 1
            let itemWidth = (self.view.frame.width - 2)/3
            cvLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            collectionView.collectionViewLayout = cvLayout
        }
        
        // Configure adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        // Configure collectionView view
        automaticallyAdjustsScrollViewInsets = false
        collectionView.backgroundColor = .white
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        initializeData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
        ])
    }
    
    private func initializeData() {
        loadData { (postsData, error) in
            guard let postsData = postsData else { return }
            self.data = postsData
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    
    func loadData(completionHandler: @escaping (_ data: [FeedItem]?, _ error: APIError?) -> Void) {
        // Make API call depending on what the dataSource type is
        let nextPage = page + 1
        switch dataSourceType! {
        case .postsLiked:
            FaceSnapsClient.sharedInstance.getLikedPosts(atPage: nextPage, completionHandler: { (posts, error) in
                completionHandler(posts, error)
            })
            break
        // TODO: Posts for Geotag
        case .postsForGeotag(let geotag):
//            FaceSnapsClient.sharedInstance.getPostsForGeotag(geotag: geotag, atPage: nextPage, completionHandler: { (posts, error) in
//                completionHandler(posts, error)
//            })
            break
        // TODO: Posts for Tag
        case .postsForTag(let tag):
//            FaceSnapsClient.sharedInstance.getPostsForTag(tag: tag, atPage: nextPage, completionHandler: { (posts, error) in
//                completionHandler(posts, error)
//            })
            break
        case .individualPost(let postId):
            FaceSnapsClient.sharedInstance.getPostData(postId: postId, completionHandler: { (post, error) in
                if let post = post {
                    completionHandler([post], nil)
                } else {
                    completionHandler(nil, error)
                }
            })
            // Do nothing if individual post
            break
        }
    }
}

// MARK: - IGListAdapterDataSource
extension PostsCollectionViewContainer: IGListAdapterDataSource {
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var objects = data as [IGListDiffable]
        
        if loading {
            objects.append(spinToken as IGListDiffable)
        }
        
//        if loading && !initLoadFeedIndicator.isAnimating {
//            objects.append(spinToken as IGListDiffable)
//        }
//        
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

// MARK: - UIScrollViewDelegate
extension PostsCollectionViewContainer: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContenopffset: UnsafeMutablePointer<CGPoint>) {
//        let distance = scrollView.contentSize.height - (targetContenopffset.pointee.y + scrollView.bounds.height)
//        if !loading && distance < 200 && !initLoadFeedIndicator.isAnimating {
//            loading = true
//            adapter.performUpdates(animated: true, completion: nil)
//            DispatchQueue.global(qos: .default).async {
//                // Load API data
//                self.loadNextPage(completionHandler: { (success, data) in
//                    // When complete:
//                    DispatchQueue.main.async {
//                        self.loading = false
//                        
//                        if let newData = data {
//                            self.data.append(contentsOf: newData)
//                            self.adapter.performUpdates(animated: true, completion: nil)
//                        }
//                    }
//                    
//                })
//            }
//        }
//    }
}

extension PostsCollectionViewContainer: FeedItemSectionDelegate, CommentDelegate, FeedItemReloadDelegate {
}
