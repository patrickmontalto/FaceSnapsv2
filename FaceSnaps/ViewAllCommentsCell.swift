//
//  ViewAllCommentsCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ViewAllCommentsCell: UICollectionViewCell {
    
    var post: FeedItem! {
        didSet {
            setButtonLabelForCommentsCount(count: post.comments.count)
        }
    }
    
    static let cellHeight: CGFloat = 24
    
    var delegate: FeedItemSectionDelegate!
    
    lazy var viewCommentsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14.0)
        btn.addTarget(self, action: #selector(viewAllCommentsPressed), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        return btn
    }()
    
    func setButtonLabelForCommentsCount(count: Int) {
        self.viewCommentsButton.setTitle("View all \(count) comments", for: .normal)
    }
    
    func viewAllCommentsPressed() {
        delegate.didPressCommentButton(forPost: self.post)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        
        contentView.addSubview(viewCommentsButton)
        
        viewCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                viewCommentsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                viewCommentsButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
}
