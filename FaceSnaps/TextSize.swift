//
//  TextSize.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/28/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

public struct TextSize {
    public static func width(_ text: String, font: UIFont) -> CGFloat {
        let string = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        let rect = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return rect.width
    }
    public static func height(_ text: String, width: CGFloat, attributes: [String: Any]?) -> CGFloat {
        
        let string = NSAttributedString(string: text, attributes: attributes)
        let rect = string.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return rect.size.height
//        let label = UILabel(frame: <#T##CGRect#>)
//        label.font = font
//        if let attributes = attributes {
//            label.attributedText = NSAttributedString(string: text, attributes: attributes)
//        } else {
//            label.text = text
//        }
//        label.numberOfLines = 0
//        label.sizeToFit()
    }
}
