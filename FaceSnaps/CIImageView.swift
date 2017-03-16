//
//  CIImageView.swift
//  FaceSnaps
//
//  Created by Patrick on 3/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import AVFoundation
import UIKit
import GLKit

/// This small GLKView subclass is used for displaying CIImages rapidly, often as the result of a CIFilter.
///
/// Assigning an image to the CIImageView's image property will result in the image getting redrawn using provided CIContext.
class CIImageView: GLKView, GLKViewDelegate {
    
    // MARK: - Properties
    var ciContext: CIContext!
    var eaglContext: EAGLContext!
    
    var image: CIImage? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Initializer
    convenience init(frame: CGRect = .zero, eaglContext: EAGLContext, ciContext: CIContext) {
        self.init(frame: frame, context: eaglContext)
        self.ciContext = ciContext
        self.eaglContext = eaglContext
        self.delegate = self
    }
    
    // MARK: - GLKViewDelegate
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // Clear the color buffer to white color
        glClearColor(1, 1, 1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        guard let image = image else { return }
        
        // Scale the rect (size should be in px, not pt)
        let scale = UIScreen.main.scale
        let scaledRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width * scale, height: rect.height * scale)
        // Create a target rect that will fit inside of the scaled rect
        let targetRect = AVMakeRect(aspectRatio: image.extent.size, insideRect: scaledRect)
        
        // Draw the image
        self.ciContext.draw(image, in: targetRect, from: image.extent)
    }
}
