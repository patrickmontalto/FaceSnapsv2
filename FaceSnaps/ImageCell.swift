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
    
    fileprivate let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    
    fileprivate let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.startAnimating()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(activityView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: ImageCell.self, for: sectionController, at: index) as! ImageCell
        
        // Check to see if the image is currently cached in the file directory
        // If it is not, begin async request to download image
        if let photo = feedItem.photo {
            cell.setImage(image: photo)
        } else {
            // TODO: Set placeholder Image
            cell.setImage(image: UIImage())
            let caching = index < 10
            // Begin background process to download image from URL
            // Cache if necessary
            feedItem.photoFromURL(cache: caching, completionHandler: { (image) in
                DispatchQueue.main.async {
                    if let cellToUpdate = collectionContext.cellForItem(at: index, sectionController: sectionController) as? ImageCell {
                        cellToUpdate.setImage(image: image)
                    }
                }
            })
        }
        
        return cell
    }
}
