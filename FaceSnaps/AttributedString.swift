//
//  AttributedString.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/7/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func NSStringWithAttributes(attributes: [String: Any], nonAttributes: [String: Any]?, nonAttrRange: NSRange?) -> NSAttributedString {
        let attrs = attributes
        var nonAttrs = nonAttributes
        
        if nonAttrs == nil {
            nonAttrs = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0),
                NSForegroundColorAttributeName: UIColor.black
            ]
        }
        
        let attrString = NSMutableAttributedString(string: self, attributes: attrs)
        
        if let range = nonAttrRange {
            attrString.setAttributes(nonAttrs, range: range)
        }
        
        
        return attrString
    }
}
