//
//  CommentController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit
import RealmSwift

protocol CommentSubmissionDelegate {
    func didSubmitComment(withText text: String)
}

class CommentController: UIViewController {
    
    // MARK: - Properties
    var post: FeedItem!
    var data: [Comment]! = []
    var delegate: FeedItemReloadDelegate!
    
    var deleteCommentIndexPath: IndexPath? = nil
    
    lazy var commentsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        let nib = UINib(nibName: "FullCommentCell", bundle: nil)
        tv.register(nib, forCellReuseIdentifier: "fullCommentCell")
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 75
        tv.clipsToBounds = true
        tv.separatorStyle = .none
        return tv
    }()

    lazy var commentBoxView: CommentBoxView = {
        let view = CommentBoxView(delegate: self)
        return view
    }()
    
    var commentBoxViewBottomAnchor: NSLayoutConstraint!
    
    // MARK: - Initializers
    convenience init(post: FeedItem, delegate: FeedItemReloadDelegate) {
        self.init()
        self.delegate = delegate
        self.post = post
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(commentsTableView)
        view.addSubview(commentBoxView)
        
        // Add caption to data
        let randomPk = Int(arc4random_uniform(9999) + 1000)
        self.data = [Comment(pk: randomPk, author: post.user!, text: post.caption, datePosted: post.datePosted)]
        
        self.title = "Comments"
        
        // Set constraint for comment box view bottom
        commentBoxViewBottomAnchor = NSLayoutConstraint(item: commentBoxView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        commentsTableView.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        
        getComments()
    
        // Hide FaceSnaps logo
        (navigationController as? HomeNavigationController)?.logoIsHidden = true
        // Hide tab bar
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            commentBoxView.height,
            commentBoxViewBottomAnchor,
            commentBoxView.leftAnchor.constraint(equalTo: view.leftAnchor),
            commentBoxView.rightAnchor.constraint(equalTo: view.rightAnchor),
            commentsTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            commentsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            commentsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: commentBoxView.topAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add notification to know when to increase/decrease the comment box view height
        NotificationCenter.default.addObserver(self, selector: #selector(adjustCommentBoxView), name: .textViewWillChangeHeightNotification, object: nil)
        // Add notification for keyboard showing/hiding
        addKeyboardObservers(showSelector: #selector(keyboardWillShow(notification:)), hideSelector: #selector(keyboardWillHide(notification:)))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    
        delegate.didUpdateFeedItem(feedItem: post)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Remove notification observers
        NotificationCenter.default.removeObserver(self, name: .textViewWillChangeHeightNotification, object: nil)
        removeKeyboardObservers()
        
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    private func getComments() {
        FaceSnapsClient.sharedInstance.getComments(forPost: post) { (comments, error) in
            guard let comments = comments else { return }
            self.data.append(contentsOf: comments)
            self.commentsTableView.reloadData()
            self.scrollToBottom()
        }
    }

    /// Scroll to the bottom of the comments table view
    func scrollToBottom() {
        let section = commentsTableView.numberOfSections - 1
        guard section >= 0 else { return }
        let item = commentsTableView.numberOfRows(inSection: section) - 1
        guard item >= 0 else { return }
        let lastIndexPath = IndexPath(item: item, section: section)
        commentsTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    /// Adjust the height of the comment box view and the uitextview for dynamic height
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
// MARK: - UITableViewDataSource & UITableViewDelegate
extension CommentController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullCommentCell", for: indexPath) as! FullCommentCell
        
        let comment = data[indexPath.row]
        cell.prepare(comment: comment, delegate: self, captionCell: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == 0 {
            return .none
        } else {
            let comment = data[indexPath.row]
            if comment.author!.pk != FaceSnapsDataSource.sharedInstance.currentUser!.pk {
                return .none
            }
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Don't allow deletion of the caption
        if indexPath.row == 0 { return }
        if editingStyle == .delete {
            deleteCommentIndexPath = indexPath
            let commentToDelete = data[indexPath.row]
            confirmDelete(comment: commentToDelete)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @objc private func confirmDelete(comment: Comment) {
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleCommentDeletion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (alert) in
            self?.deleteCommentIndexPath = nil
        }
        displayAlert(withMessage: "Are you sure you want to delete your comment?", title: "Delete Comment", actions: [deleteAction, cancelAction], style: .actionSheet)
    }
    
    @objc private func handleCommentDeletion(alert: UIAlertAction!) {
        if let indexPath = deleteCommentIndexPath {
            let comment = data[indexPath.row]
            FaceSnapsClient.sharedInstance.deleteComment(comment, post: post, completionHandler: { (success) in
                if success {
                    // TODO: Post notification to remove comment from post throughout application
                    //let predicate = NSPredicate(format: "pk != %@", comment.pk)
                    self.post.comments.remove(objectAtIndex: indexPath.row - 1)
                    let userInfo = ["post": self.post]
                    NotificationCenter.default.post(name: .postWasModifiedNotification, object: self, userInfo: userInfo)
                    self.removeCommentFromTableView(indexPath: indexPath)
                } else {
                    self.displayNotification(withMessage: "Unable to delete comment.", completionHandler: nil)
                }
            })
            
        }
    }
    
    @objc private func removeCommentFromTableView(indexPath: IndexPath) {
        commentsTableView.beginUpdates()
        
        data.remove(at: indexPath.row)
        commentsTableView.deleteRows(at: [indexPath], with: .automatic)
        
        deleteCommentIndexPath = nil
        
        commentsTableView.endUpdates()
    }

}

// MARK: - CommentDelegate
// This is responsible for handling taps on the comment cell, such as reply and tapping the user icon for the cell
extension CommentController: CommentDelegate {
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
                self.commentsTableView.reloadData()
                self.scrollToBottom()
            } else {
                // TODO: Notify user of error with alert
                let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                APIErrorHandler.handle(error: error!, withActions: [action], presentingViewController: self)
            }
        }
    }
}

