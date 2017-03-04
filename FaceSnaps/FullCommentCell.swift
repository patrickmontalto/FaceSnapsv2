//
//  FullCommentCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import ActiveLabel

class FullCommentCell: UITableViewCell {
    
    static func cellHeight(forComment comment: Comment) -> CGFloat {
        let author = comment.author!.userName
        let text = comment.text
        let labelHeight = TextSize.height(author + text, width: UIScreen.main.bounds.width - 106, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])

        return labelHeight + 50
    }
    
    var comment: Comment!
    var delegate: CommentDelegate!
    
    @IBOutlet var userIconView: UIImageView!
    
    @IBOutlet var commentLabel: ActiveLabel!
    
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var timeLabel: UILabel!

    
    func prepare(comment: Comment, delegate: CommentDelegate, captionCell: Bool) {
        self.comment = comment
        self.delegate = delegate
        
        // Reply button
        replyButton.setTitle("Reply", for: .normal)
        replyButton.setTitleColor(.gray, for: .normal)
        replyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        replyButton.titleLabel?.font = .boldSystemFont(ofSize: 12.0)
        replyButton.addTarget(self, action: #selector(handleReplyTap), for: .touchUpInside)

        
        // Time label
        timeLabel.numberOfLines = 1
        timeLabel.textColor = .gray
        timeLabel.font = .systemFont(ofSize: 12.0)
        timeLabel.text = Timer.timeAgoSinceDate(date: comment.datePosted as NSDate, numericDates: true, shortened: true)
        userIconView.image = comment.author?.photo?.circle ?? UIImage()
        
        // commentLabel
        let author = comment.author!
        let text = comment.text

        // Set contentLabel to interactable label with author and caption
        commentLabel.setContentForCommentLabel(author: author, caption: text, delegate: delegate)
        commentLabel.numberOfLines = 0

        
        if captionCell {
            timeLabel.isHidden = true
            replyButton.isHidden = true
        }
    }
    
        func handleReplyTap() {
        delegate?.didTapReply(toAuthor: comment.author!)
    }

}
