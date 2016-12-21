//
//  LoginTextField.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 11/29/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    
    var inset: CGFloat = 16
    var tintedClearImage: UIImage?
    
    convenience init(text: String) {
        self.init(frame: .zero)
        let extraLightGray = UIColor(white: 245/255, alpha: 0.8)
        // Set white placeholder
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: extraLightGray])
        self.textColor = .white
        self.font = .systemFont(ofSize: 14)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        self.layer.cornerRadius = 4.0
        self.clearButtonMode = UITextFieldViewMode.whileEditing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Inset text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    // MARK: - ClearButton Customization
    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage(color: .lightGray)
    }
    
    private func tintClearImage(color: UIColor) {
        for view in subviews {
            if view is UIButton {
                let button = view as! UIButton
                if let uiImage = button.image(for: .highlighted) {
                    if tintedClearImage == nil {
                        tintedClearImage = tintImage(image: uiImage, color: color)
                    }
                    button.setImage(tintedClearImage, for: .normal)
                    button.setImage(tintedClearImage, for: .highlighted)
                }
            }
        }
    }
    
    func tintImage(image: UIImage, color: UIColor) -> UIImage {
        let size = image.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        if let context = UIGraphicsGetCurrentContext() {
            image.draw(at: .zero, blendMode: .normal, alpha: 1.0)
            
            context.setFillColor(color.cgColor)
            context.setBlendMode(CGBlendMode.sourceIn)
            context.setAlpha(0.9)
            
            let rect = CGRect(x: CGPoint.zero.x, y: CGPoint.zero.y, width: size.width, height: size.height)
            
            context.fill(rect)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage!
    }
}
