//
//  ImageCropHelper.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/1/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import AVFoundation

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
    static func cropToImageCropView(_ cropView: FSImageCropView) -> UIImage {
        
        let normalizedX = (cropView)
        
        return UIImage()
    }
}
