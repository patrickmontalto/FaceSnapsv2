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
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1.0)
        return view
    }()
    
    private lazy var captionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.delegate = self
        textView.isScrollEnabled = true
        textView.text = "Write a caption..."
        textView.textColor = .lightGray
        return textView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            thumbnailView.heightAnchor.constraint(equalToConstant: 72),
            thumbnailView.widthAnchor.constraint(equalToConstant: 72),
            thumbnailView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            thumbnailView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            captionTextView.heightAnchor.constraint(equalToConstant: 72),
            captionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            captionTextView.leftAnchor.constraint(equalTo: thumbnailView.rightAnchor, constant: 8),
            captionTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            bottomBorder.heightAnchor.constraint(equalToConstant: 0.5),
            bottomBorder.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    
    // MARK: - Interface
    func prepareView(withDelegate delegate: PostHeaderViewDelegate) {
        self.delegate = delegate
        
        addSubview(thumbnailView)
        addSubview(captionTextView)
        addSubview(bottomBorder)
        
        contentView.backgroundColor = .white
    }
    
    var captionText: String? {
        return captionTextView.text
    }
    
    func handleThumbnailTap() {
        delegate.tappedThumbnail()
    }
}

extension PostHeaderView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption..."
            textView.textColor = .lightGray
        }
    }
}

/// PostHeaderViewDelegate is responsible for supplying the image to the imgView, responding to
/// when the thumbnail is tapped, and serves as the delegate for the caption text field.
protocol PostHeaderViewDelegate: UITextFieldDelegate {
    func imageForPost() -> UIImage
    func tappedThumbnail()
}
