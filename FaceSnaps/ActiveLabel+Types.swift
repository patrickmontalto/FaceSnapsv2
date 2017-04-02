//
//  ActiveLabel+Types.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import ActiveLabel

extension ActiveLabel {
    
    func setContentForCommentLabel(author: User, caption: String, delegate: CommentDelegate) {
        let authorName = author.userName
        let authorType = ActiveType.custom(pattern: "^\(authorName)\\b")
        
        let content = "\(authorName) \(caption)"
        
        self.enabledTypes = [.hashtag, .mention, authorType]
        self.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            switch type {
            case .custom( _):
                atts[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 14.0)
            default:
                atts[NSFontAttributeName] = UIFont.systemFont(ofSize: 14.0)
            }
            return atts
        }
        
        self.text = content
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 14.0)
        
        self.handleHashtagTap { (tag) in
            delegate.didTapHashtag(tag: tag)
        }
        
        self.handleMentionTap { (username) in
            // Find user by username
            FaceSnapsClient.sharedInstance.searchUsers(queryString: username, completionHandler: { (users, error) in
                guard let users = users, users.count > 0 else {
                    return
                }
                let user = users.first!
                delegate.didTapAuthor(author: user)
            })
        }
        
        self.hashtagColor = .hashtagBlue
        self.mentionColor = .hashtagBlue
        
        self.handleCustomTap(for: authorType) { (authorName) in
            delegate.didTapAuthor(author: author)
        }
        
        self.customColor[authorType] = UIColor.black
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    static func commentLabel(author: User, caption: String, delegate: CommentDelegate) -> ActiveLabel {
        let authorName = author.userName
        let authorType = ActiveType.custom(pattern: "^\(authorName)\\b")
        
        let content = "\(authorName) \(caption)"
        
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.hashtag, .mention, authorType]
        label.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            switch type {
            case .custom( _):
                atts[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 14.0)
            default:
                atts[NSFontAttributeName] = UIFont.systemFont(ofSize: 14.0)
            }
            return atts
        }
        
        label.text = content
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        label.handleHashtagTap { (tag) in
            delegate.didTapHashtag(tag: tag)
        }
        
        label.handleMentionTap { (username) in
            delegate.didTapMention(username: username)
        }
        
        label.hashtagColor = .hashtagBlue
        label.mentionColor = .hashtagBlue
        
        label.handleCustomTap(for: authorType) { (authorName) in
            delegate.didTapAuthor(author: author)
        }
        
        label.customColor[authorType] = UIColor.black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static func captionLabel(author: User, caption: String, delegate: CommentDelegate) -> ActiveLabel {
        let label = commentLabel(author: author, caption: caption, delegate: delegate)
        label.numberOfLines = 5
        return label
    }
    
}
