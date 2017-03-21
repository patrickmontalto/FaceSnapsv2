//
//  PostHeaderView.swift
//  FaceSnaps
//
//  Created by Patrick on 3/21/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

class PostHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    static let height: CGFloat = 88
    static let reuseIdentifier = String(describing: PostHeaderView.self)
    
    private var delegate: PostHeaderViewDelegate!
    
    private lazy var thumbnailTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.handleThumbnailTap))
    }()
    
    private lazy var thumbnailView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = self.delegate.imageForPost()
        imgView.addGestureRecognizer(self.thumbnailTapGesture)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var captionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Write a caption..."
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.delegate = self.delegate
        return textField
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            thumbnailView.heightAnchor.constraint(equalToConstant: 80),
            thumbnailView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            thumbnailView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            captionTextField.heightAnchor.constraint(equalToConstant: 80),
            captionTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            captionTextField.leftAnchor.constraint(equalTo: thumbnailView.rightAnchor, constant: 8),
            captionTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
        ])
    }
    
    
    // MARK: - Interface
    func prepareView(withDelegate delegate: PostHeaderViewDelegate) {
        self.delegate = delegate
        
        addSubview(thumbnailView)
        addSubview(captionTextField)
        
        contentView.backgroundColor = .white
    }
    
    var captionText: String? {
        return captionTextField.text
    }
    
    func handleThumbnailTap() {
        delegate.tappedThumbnail()
    }
}

/// PostHeaderViewDelegate is responsible for supplying the image to the imgView, responding to
/// when the thumbnail is tapped, and serves as the delegate for the caption text field.
protocol PostHeaderViewDelegate: UITextFieldDelegate {
    func imageForPost() -> UIImage
    func tappedThumbnail()
}
