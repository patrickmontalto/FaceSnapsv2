//
//  FSImageCropView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/5/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class FSImageCropView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: - Properties
    var imageView = UIImageView()
    var imageSize: CGSize?
    var image: UIImage! = nil {
        didSet {
            if image != nil {
                if !imageView.isDescendant(of: self) {
                    self.imageView.alpha = 1.0
                    self.addSubview(imageView)
                }
            } else {
                imageView.image = nil
                return
            }
            
            let imageSize = self.imageSize ?? image.size
            
            let ratioWidth = frame.width / imageSize.width
            let ratioHeight = frame.height / imageSize.height
            
            if ratioHeight > ratioWidth {
                imageView.frame = CGRect(origin: .zero, size: CGSize(width: imageSize.width * ratioHeight, height: frame.height))
            } else {
                imageView.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: imageSize.height * ratioWidth))
            }
            
            contentOffset = CGPoint(x: imageView.center.x - center.x, y: imageView.center.y - center.y)
            
            contentSize = CGSize(width: imageView.frame.width + 1, height: imageView.frame.height + 1)
            
            imageView.image = image
            
            zoomScale = 1.0
        }
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        clipsToBounds = true
        imageView.alpha = 0.0
        
        imageView.frame = CGRect(origin: .zero, size: .zero)
        
        maximumZoomScale = 2.0
        minimumZoomScale = 0.8
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bouncesZoom = true
        bounces = true
        scrollsToTop = false
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        self.contentSize = CGSize(width: imageView.frame.width + 1, height: imageView.frame.height + 1)
    }

}
