//
//  ImageCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

class ImageCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    var post: FeedItem?
    var delegate: FeedItemSectionDelegate?
    weak var sectionController: FeedItemSectionController?
    
    // MARK: - Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.startAnimating()
        return view
    }()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(activityView)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        gestureRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewCell
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityView.center = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        imageView.frame = bounds
    }
    
    func setImage(image: UIImage?) {
        imageView.image = image
        if image != nil {
            activityView.stopAnimating()
        } else {
            activityView.startAnimating()
        }
    }

    
    func configureCell(post: FeedItem, sectionController: FeedItemSectionController) {
        setImage(image: post.photo)
        self.post = post
        self.delegate = sectionController.feedItemSectionDelegate
        self.sectionController = sectionController
    }
    
    @objc private func handleImageTap() {
        guard let delegate = delegate, let post = self.post, let sectionController = self.sectionController else { return }
        delegate.didTapImage(forPost: post, imageView: self.imageView, inSectionController: sectionController)
    }
    
    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: ImageCell.self, for: sectionController, at: index) as! ImageCell
        cell.configureCell(post: feedItem, sectionController: sectionController as! FeedItemSectionController)
        // Check to see if the image is currently cached in the file directory
        // If it is not, begin async request to download image
        if feedItem.photo == nil {
            // TODO: Set placeholder Image
            cell.setImage(image: UIImage())
            let caching = index < 10
            // Begin background process to download image from URL
            // Cache if necessary
            ImageLoader.sharedInstance.loadImageForPost(feedItem, cache: caching, completion: { (image) in
                guard let image = image else {
                    print("No image returned for photoURLString")
                    return
                }
                cell.setImage(image: image)
            })
        } else {
            cell.setImage(image: feedItem.photo!)
        }
        
        return cell
    }
}
