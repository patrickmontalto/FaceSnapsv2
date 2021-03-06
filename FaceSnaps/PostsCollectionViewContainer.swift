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
    case postsForTag(tag: Tag, atRow: Int)
    case postsForLocation(location: FourSquareLocation, atRow: Int)
    case individualPost(postId: Int)
}

class PostsCollectionViewContainer: UIViewController, CollectionViewContainer {
    
    var data = [FeedItem]()
    var page = 0
    var loading = false
    let spinToken = "spinner"
    
    var startingRow = 0
    
    lazy var initLoadFeedIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dataSourceType: PostsCollectionViewDataSourceType!
    var style: PostsCollectionViewContainerStyle!
    
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
        self.style = style
        
        // Default style is feed. If thumbnails, change flow layout for collectionView
        if style == .thumbnails {
            let gridLayout = IGListGridCollectionViewLayout()
            gridLayout.minimumLineSpacing = 1
            gridLayout.minimumInteritemSpacing = 1
            let itemWidth = (self.view.frame.width - 2)/3
            gridLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            collectionView.collectionViewLayout = gridLayout
        }
        
        // Configure adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        // Configure collectionView view
        automaticallyAdjustsScrollViewInsets = false
        collectionView.backgroundColor = .white
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        initializeData()
        
        // Add notification to observe changes in the post
        observePostUpdateNotifications(responseSelector: #selector(updatePostInData(_:)))
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
            self.adapter.performUpdates(animated: true, completion: { (completed) in
                if let object = self.adapter.object(atSection: self.startingRow) {
                    self.adapter.scroll(to: object, supplementaryKinds: nil, scrollDirection: .vertical, scrollPosition: .top, animated: true)
                }
            })
            
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
        case .postsForLocation(let location, let row):
            // Get posts for location
            FaceSnapsClient.sharedInstance.getPosts(forLocation: location) { (data, error) in
                if let data = data {
                    completionHandler(data, nil)
                    self.startingRow = row
                } else {
                    completionHandler(nil, error!)
                    _ = APIErrorHandler.handle(error: error!, logError: true)
                }
            }
            break
        // TODO: Posts for Tag
        case .postsForTag(let tag, let row):
            FaceSnapsClient.sharedInstance.getPosts(forTag: tag, completionHandler: { (data, error) in
                if let data = data {
                    completionHandler(data, nil)
                    self.startingRow = row
                } else {
                    completionHandler(nil, error!)
                    _ = APIErrorHandler.handle(error: error!, logError: true)
                }
            })
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
        
        if loading && !initLoadFeedIndicator.isAnimating {
            objects.append(spinToken as IGListDiffable)
        }
        
        return objects
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else if style == .thumbnails {
            return FeedItemThumbnailSectionController(parentViewController: self)
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

