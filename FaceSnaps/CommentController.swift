//
//  CommentController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

protocol CommentSubmissionDelegate {
    func didSubmitComment(withText text: String)
}

class CommentController: UIViewController {
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var post: FeedItem!
    var data: [Comment]! = []
    var delegate: FeedItemReloadDelegate!
    var panGesture: UIPanGestureRecognizer!
    
    convenience init(post: FeedItem, delegate: FeedItemReloadDelegate) {
        self.init()
        self.delegate = delegate
        self.post = post
    }
    
    lazy var collectionView: IGListCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        let cv = IGListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    lazy var commentBoxView: CommentBoxView = {
        let view = CommentBoxView(delegate: self)
        return view
    }()
    
    var commentBoxViewBottomAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(commentBoxView)
        
        // Add caption to data
        let randomPk = Int(arc4random_uniform(9999) + 1000)
        self.data = [Comment(pk: randomPk, author: post.user!, text: post.caption, datePosted: post.datePosted)]
        
        self.title = "Comments"
        
        // Set constraint for comment box view bottom
        commentBoxViewBottomAnchor = NSLayoutConstraint(item: commentBoxView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        collectionView.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        getComments()
        
        // Hide FaceSnaps logo
        (navigationController as? HomeNavigationController)?.logoIsHidden = true
        // Hide tab bar
        tabBarController?.tabBar.isHidden = true
        
        // Add notification to know when to increase/decrease the comment box view height
        NotificationCenter.default.addObserver(self, selector: #selector(adjustCommentBoxView), name: .textViewWillChangeHeightNotification, object: nil)
        // Add notification for keyboard showing/hiding
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        // Add pan gesture to collectionView
        setPanGesture()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            commentBoxView.height,
            commentBoxViewBottomAnchor,
            commentBoxView.leftAnchor.constraint(equalTo: view.leftAnchor),
            commentBoxView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: commentBoxView.topAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentBoxView.showKeyboard()
    }
    
    // MARK: Create gesture for swiping cells
    private func setPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCell(_:)))
        panGesture.delegate = self
        collectionView.addGestureRecognizer(panGesture)
    }
    func panCell(_ recognizer: UIPanGestureRecognizer) {
        if recognizer != panGesture { return }
        
        let point = recognizer.location(in: collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: point) else {
            return
        }
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? FullCommentCell else {
            return
        }
        
        
    }
    
    private func getComments() {
        FaceSnapsClient.sharedInstance.getComments(forPost: post) { (comments, error) in
            guard let comments = comments else { return }
            self.data.append(contentsOf: comments)
            self.adapter.performUpdates(animated: true, completion: { (completed) in
            })
        }
    }
    
    func scrollToBottom() {
        let section = collectionView.numberOfSections - 1
        guard section >= 0 else { return }
        let item = collectionView.numberOfItems(inSection: section) - 1
        guard item >= 0 else { return }
        let lastIndexPath = IndexPath(item: item, section: section)
        collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    // Adjust the height of the comment box view and the uitextview for dynamic height
    func adjustCommentBoxView() {
        let height = commentBoxView.commentTextViewHeight.constant + 32
        commentBoxView.height.constant = height
    }
    
    // MARK: - Keyboard Notifications
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.commentBoxViewBottomAnchor.constant -= keyboardSize.height

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.scrollToBottom()
        })
 
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.commentBoxViewBottomAnchor.constant += keyboardSize.height
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - IGListAdapterDataSource
extension CommentController: IGListAdapterDataSource {
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return data as [IGListDiffable]
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return CommentSectionController(commentDelegate: self)
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - CommentDelegate
// This is responsible for handling taps on the comment cell, such as reply and tapping the user icon for the cell
extension CommentController: CommentDelegate {
    func didTapAuthor(author: User) {
        // TODO: Present user profile
    }
    
    func didTapReply(toAuthor author: User) {
        if commentBoxView.commentTextView.text == "Add a comment..." {
            commentBoxView.commentTextView.text = "@\(author.userName) "
            commentBoxView.commentTextView.textColor = .black
        } else {
            var text = commentBoxView.commentTextView.text!
            if text.characters.last == " " {
                text += "@\(author.userName) "
            } else {
                text += " @\(author.userName) "
            }
            commentBoxView.commentTextView.text = text
            commentBoxView.textViewDidChange(commentBoxView.commentTextView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.didUpdateFeedItem(feedItem: post)
    }
}

extension CommentController: CommentSubmissionDelegate {
    func didSubmitComment(withText text: String) {
        // Handle POSTing comment
        // Maybe post notification to get new comments for post X? Then reload adapter ?
        FaceSnapsClient.sharedInstance.postComment(onPost: post, withText: text) { (comment, error) in
            if let comment = comment {
                // Clear comment box
                self.commentBoxView.setPlaceholder()
                // Successfully posted comment. Append to data
                self.post.comments.insert(comment, at: 0)
                self.data.append(comment)
                self.adapter.performUpdates(animated: true, completion: { (completed) in
                    self.scrollToBottom()
                })
            } else {
                // TODO: Notify user of error with alert
                let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                APIErrorHandler.handle(error: error!, withActions: [action], presentingViewController: self)
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CommentController: UIGestureRecognizerDelegate {
    
}

