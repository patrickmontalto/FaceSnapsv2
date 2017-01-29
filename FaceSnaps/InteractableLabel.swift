//
//  InteractableLabel.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/17/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit


enum InteractableLabelType {
    case getHelp, signUp, signIn, goBack, comment, none
    
    func labelText() -> String {
        switch self {
        case .getHelp:
            return "Forgot your login details? Get help signing in."
        case .signUp:
            return "Don't have an account? Sign Up."
        case .signIn:
            return "Already have an account? Sign In."
        case .goBack:
            return "Back To Log In"
        default:
            return String()
        }
    }
    
    func nonBoldRange() -> NSRange {
        switch self {
        case .getHelp:
            return NSMakeRange(0, 26)
        case .signUp:
            return NSMakeRange(0, 23)
        case .signIn:
            return NSMakeRange(0, 25)
        case .goBack:
            return NSMakeRange(0, 0)
        default:
            return NSRange()
        }
    }
    
    func boldRange() -> NSRange {
        switch self {
        case .getHelp:
            return NSMakeRange(27, 20)
        case .signUp:
            return NSMakeRange(24, 8)
        case .signIn:
            return NSMakeRange(25, 8)
        case .goBack:
            return NSMakeRange(0, 14)
        default:
            return NSRange()
        }
    }
}
class InteractableLabel: UILabel {
    
    var boldRange: NSRange
    var nonBoldRange: NSRange
    
    convenience init(type: InteractableLabelType) {
        self.init(frame: .zero)
        
        let text = type.labelText()
        nonBoldRange = type.nonBoldRange()
        boldRange = type.boldRange()
        
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let nonAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        attributedText = text.NSStringWithAttributes(attributes: attributes, nonAttributes: nonAttributes, nonAttrRange: nonBoldRange)
        
        sizeToFit()
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(type: InteractableLabelType, boldText: String, nonBoldText: String) {
        self.init(frame: .zero)
        
        let text = boldText + "  " + nonBoldText
        self.boldRange = NSMakeRange(0, boldText.characters.count)
        self.nonBoldRange = NSMakeRange(boldText.characters.count, nonBoldText.characters.count + 2)
        
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
        
        let nonAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
        
        attributedText = text.NSStringWithAttributes(attributes: attributes, nonAttributes: nonAttributes, nonAttrRange: nonBoldRange)
        
        numberOfLines = 0
        
        sizeToFit()
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        self.boldRange = NSRange()
        self.nonBoldRange = NSRange()
        
        super.init(frame: frame)
    }
    
    func setTextColors(nonBoldColor: UIColor, boldColor: UIColor) {
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: boldColor
        ]
        
        let nonAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: nonBoldColor
        ]
        
        attributedText = text?.NSStringWithAttributes(attributes: attributes, nonAttributes: nonAttributes, nonAttrRange: nonBoldRange)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
