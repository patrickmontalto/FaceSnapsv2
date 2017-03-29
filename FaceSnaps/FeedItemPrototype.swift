//
//  Post.swift
//  FaceSnaps
//
//  Created by Patrick on 3/28/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

struct FeedItemPrototype {
    enum Key {
        static let post = "post"
        static let location = "location"
        static let photo = "photo"
        static let caption = "caption"
    }
    
    var photo: UIImage
    var caption: String
    var location: FourSquareLocation?
    
    var params: [String: Any] {
        let base64string = "data:image/jpeg;base64,\(ImageCoder.encodeToBase64(image: photo)!)"
        if let location = location {
            return [Key.post: [Key.caption: caption, Key.photo: base64string], Key.location: location.parameterized ]
        } else {
            return [Key.post: [Key.caption: caption, Key.photo: base64string] ]
        }
    }
}
