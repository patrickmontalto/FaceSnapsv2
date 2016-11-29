//
//  PhotoCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/8/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "\(PhotoCell.self)"
    
    let imageView = UIImageView()
    
    var deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    
    override func layoutSubviews() {
        // Photo image
        contentView.addSubview(imageView)
        
        // Delete button (hidden by default)
        let deleteIcon = UIImage(named: "delete_icon")!
        deleteButton.setBackgroundImage(deleteIcon, for: .normal)
        
        contentView.addSubview(deleteButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func deletePhoto(sender: UIButton) {
        // Need to tell the PhotoListController to deletePhoto
    }
}

























