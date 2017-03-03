//
//  ActiveLabel+Types.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import ActiveLabel

extension ActiveLabel {
    
    static func captionLabel(author: User, caption: String, delegate: CommentDelegate) -> ActiveLabel {
        let authorName = author.userName
        let authorType = ActiveType.custom(pattern: "^\(authorName)\\b")
        
        let content = "\(authorName) \(caption)"
        
        let label = ActiveLabel()
        label.numberOfLines = 5
        label.enabledTypes = [.hashtag, .mention, authorType]
        label.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            switch type {
            case .custom(let _):
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
        
        label.hashtagColor = .hashtagBlue
        label.mentionColor = .hashtagBlue
        
        label.handleCustomTap(for: authorType) { (authorName) in
            delegate.didTapAuthor(author: author)
        }
        
        label.customColor[authorType] = UIColor.black
        
        return label
    }
    
//    static func commentLabel() -> ActiveLabel {
//        
//    }
}
