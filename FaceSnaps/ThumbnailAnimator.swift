//
//  ThumbnailAnimator.swift
//  FaceSnaps
//
//  Created by Patrick on 3/28/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

class ThumbnailAnimator {
    var thumbnail: UIImageView
    var viewController: UIViewController
    
    lazy var thumbnailRect: CGRect = {
        return self.thumbnail.convert(self.thumbnail.bounds, to: self.viewController.view)
    }()
    
    let imageDimension = UIScreen.main.bounds.width
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    var thumbnailEnlarged: Bool {
        return animatedImage.frame.height == UIScreen.main.bounds.width
    }
    
    private lazy var thumbnailTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.handleThumbnailTap))
    }()
    
    private lazy var backgroundTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.handleThumbnailTap))
    }()
    
    lazy var animatedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.thumbnail.image!
        imageView.frame = self.thumbnailRect
        imageView.addGestureRecognizer(self.thumbnailTapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    init(thumbnail: UIImageView, viewController: UIViewController) {
        self.thumbnail = thumbnail
        self.viewController = viewController
        
        viewController.view.addSubview(dimmingView)
        viewController.view.addSubview(animatedImage)
        viewController.view.addGestureRecognizer(backgroundTapGesture)
        backgroundTapGesture.isEnabled = false
    }
    
    @objc private func handleThumbnailTap() {
        if thumbnailEnlarged {
            dismissThumbnail()
            backgroundTapGesture.isEnabled = false
        } else {
            enlargeThumbnail()
            backgroundTapGesture.isEnabled = true
        }
    }
    
    private func enlargeThumbnail() {
        // Show the dimming view
        enableDimmingView(true)
        // Hide the thumbnail view
        DispatchQueue.main.async {
            self.thumbnail.isHidden = true
        }
        // Animate the enlarging of the animated image view
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5 , options: .curveEaseIn, animations: {
            let yPosition = (UIScreen.main.bounds.height - self.imageDimension) / 2.0
            self.animatedImage.frame = CGRect(x: 0, y: yPosition, width: self.imageDimension, height: self.imageDimension)
        }, completion: { (completed) in
            
        })
    }
    
    private func dismissThumbnail() {
        // Hide the dimming view
        enableDimmingView(false)
        // Animate the dismissing of the animated image view
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 2 , options: .curveEaseInOut, animations: {
            self.animatedImage.frame = self.thumbnailRect
        }, completion: { (completed) in
            self.thumbnail.isHidden = false
        })
    }
    
    private func enableDimmingView(_ enabled: Bool) {
        let alpha: CGFloat = enabled ? 0.7 : 0.0
        UIView.animate(withDuration: 0.2) {
            self.dimmingView.alpha = alpha
        }
    }
}
