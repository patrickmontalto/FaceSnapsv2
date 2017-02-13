//
//  FullCommentCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class FullCommentCell: UICollectionViewCell {
    
    static func cellHeight(forComment comment: Comment) -> CGFloat {
        let author = comment.author!.userName
        let text = comment.text
        let labelHeight = TextSize.height(author + text, width: UIScreen.main.bounds.width - 106, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        
        return labelHeight + 42
    }
    
    var delegate: CommentDelegate?
    
    var heightConstraint: NSLayoutConstraint!
    
    var comment: Comment! {
        didSet {
            setLabelContent()
            isCaptionCell = false
        }
    }
    
    var isCaptionCell: Bool? {
        didSet {
            if (isCaptionCell!) {
                timeLabel.isHidden = true
                replyButton.isHidden = true
            }
        }
    }
    
    let userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var contentLabel: InteractableLabel = {
        return InteractableLabel()
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()
    
    private var replyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reply", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        button.addTarget(self, action: #selector(handleReplyTap), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12.0)
        return button
    }()
    
    let divider: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    lazy var authorTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(tapGesture:)))
    }()
    
    private func setLabelContent() {
        setContentLabel()
        timeLabel.text = Timer.timeAgoSinceDate(date: comment.datePosted as NSDate, numericDates: true, shortened: true)
        userIcon.image = comment.author?.photo?.circle ?? UIImage()
    }
    
    private func setContentLabel() {
        
        // Get author and caption strings
        let author = comment.author!.userName
        let text = comment.text
        
        // Set contentLabel to interactable label with author and caption
        self.contentLabel = InteractableLabel(type: .comment, boldText: author, nonBoldText: text)
        
        self.contentLabel.numberOfLines = 0
        
        self.contentLabel.addGestureRecognizer(self.authorTap)
    }
    
    // Notify the delegate of which author got tapped
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        if tapGesture.didTapAttributedTextInLabel(label: contentLabel, inRange: contentLabel.boldRange) {
            delegate?.didTapAuthor(author: comment.author!)
        }
    }
    
    func handleReplyTap() {
        delegate?.didTapReply(toAuthor: comment.author!)
    }

    override func layoutSubviews() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        heightConstraint.constant = frame.height
        
        contentView.addSubview(contentLabel)
        contentView.addSubview(userIcon)
        contentView.addSubview(timeLabel)
        contentView.addSubview(replyButton)
        contentView.addSubview(divider)
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            userIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            userIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            userIcon.heightAnchor.constraint(equalToConstant: 32.0),
            userIcon.widthAnchor.constraint(equalToConstant: 32.0),
            contentLabel.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            heightConstraint,
//            contentView.heightAnchor.constraint(equalToConstant: frame.height),
            contentView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 50),
            timeLabel.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            replyButton.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            replyButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 56),
            divider.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        self.contentLabel = InteractableLabel()
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        let height = FullCommentCell.cellHeight(forComment: comment)
        heightConstraint.constant = height
        super.prepareForReuse()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

}
