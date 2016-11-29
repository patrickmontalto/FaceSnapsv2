//
//  FilteredImageCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/3/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import GLKit

class FilteredImageCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: FilteredImageCell.self)
    
    var eaglContext: EAGLContext!
    var ciContext: CIContext!
    
    // Use GLK View
    lazy var glkView: GLKView = {
        // We need the eaglContext to initialize this view.
        // We make this lazy so that we only create the glkView when needed
        // By the time it is called, the eaglContext should already be initialized and available for use
        let view = GLKView(frame: self.contentView.frame, context: self.eaglContext)
        view.delegate = self
        return view
    }()
    
    var image: CIImage!
    
    // In UIView Subclass, do layout in layoutSubviews()
    override func layoutSubviews() {
        // Add subviews to contentView
        contentView.addSubview(glkView)
        glkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                glkView.topAnchor.constraint(equalTo: contentView.topAnchor),
                glkView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                glkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                glkView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
    
}

// MARK: - GLKViewDelegate
extension FilteredImageCell: GLKViewDelegate {
    // Renders drawing onto actual view
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        // First create a CGSize value that encapsulates the space we want to draw in.
        let drawableRectSize = CGSize(width: glkView.drawableWidth, height: glkView.drawableHeight)
        // Then create a rect with that size
        let drawableRect = CGRect(origin: CGPoint.zero, size: drawableRectSize)
        
        ciContext.draw(image, in: drawableRect, from: image.extent)
    }
}
























