//
//  ImageCropHelper.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/1/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ImageCropHelper {
    // TODO: Make sure this image is high enough resolution
    static func cropToPreviewLayer(previewLayer: AVCaptureVideoPreviewLayer, originalImage: UIImage) -> UIImage {
        let outputRect = previewLayer.metadataOutputRectOfInterest(for: previewLayer.bounds)
        var cgImage = originalImage.cgImage!
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)

        cgImage = cgImage.cropping(to: cropRect)!
        let croppedUIImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .leftMirrored)

        return croppedUIImage
    }
    
    static func cropToImageCropView(_ cropView: FSImageCropView, asset: PHAsset, cropHeightRatio: CGFloat, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        
        let normalizedX = cropView.contentOffset.x / cropView.contentSize.width
        let normalizedY = cropView.contentOffset.y / cropView.contentSize.height
        
        let normalizedWidth = cropView.frame.width / cropView.contentSize.width
        let normalizedHeight = cropView.frame.height / cropView.contentSize.height
        
        let cropRect = CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
        
        DispatchQueue.global(qos: .default).async { 
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.normalizedCropRect = cropRect
            options.resizeMode = .exact
            
            let targetWidth = floor(CGFloat(asset.pixelWidth) * cropRect.width)
            let targetHeight = floor(CGFloat(asset.pixelHeight) * cropRect.height)
            let dimensionW = max(min(targetHeight, targetWidth), 1024 * UIScreen.main.scale)
            let dimensionH = dimensionW * cropHeightRatio
            
            let targetSize = CGSize(width: dimensionW, height: dimensionH)
            
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                completionHandler(image)
            })
            
        }
    }
}
