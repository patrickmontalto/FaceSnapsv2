//
//  FilteredImageBuilder.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/2/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

/// This class applies filters to the supplied image.
final class FilteredImageBuilder {
    
    // MARK: - Properties
    let ColorClamp = "CIColorClamp"
    let ColorControls = "CIColorControls"
    let PhotoEffectTransfer = "CIPhotoEffectTransfer"
    let PhotoEffectChrome = "CIPhotoEffectChrome"
    let PhotoEffectInstant = "CIPhotoEffectInstant"
    let PhotoEffectProcess = "CIPhotoEffectProcess"
    let PhotoEffectNoir = "CIPhotoEffectNoir"
    let Sepia = "CISepiaTone"
    let HighlightShadowAdjust = "CIHighlightShadowAdjust"
    
    var filteredImages = [FSImageFilter: UIImage]()
    
    private let context: CIContext
    
    // MARK: - Initializer
    init(context: CIContext) {
        self.context = context
    }
    
    // MARK: - Apply Filter Functions
    
    func applyClarendon(image: CIImage) -> CIImage {
        let clarendonFilter = CIFilter(name: PhotoEffectProcess)!
        clarendonFilter.setValue(image, forKey: kCIInputImageKey)
        return clarendonFilter.outputImage!.cropping(to: image.extent)
    }
    
    func applyGingham(image: CIImage) -> CIImage {
        let ginghamFilter = CIFilter(name: PhotoEffectTransfer)!
        ginghamFilter.setValue(image, forKey: kCIInputImageKey)
        return ginghamFilter.outputImage!.cropping(to: image.extent)
    }

    func applyMoon(image: CIImage) -> CIImage {
        let moonFilter = CIFilter(name: PhotoEffectNoir)!
        moonFilter.setValue(image, forKey: kCIInputImageKey)
        return moonFilter.outputImage!.cropping(to: image.extent)
    }
    
    func applyLark(image: CIImage) -> CIImage {
        let highlightsFilter = CIFilter(name: HighlightShadowAdjust)!
        let highlights: NSNumber = 4.0
        highlightsFilter.setValue(image, forKey: kCIInputImageKey)
        highlightsFilter.setValue(highlights, forKey: "inputHighlightAmount")
        let highlightedImage = highlightsFilter.outputImage!
        
        let brightnessFilter = CIFilter(name: ColorControls)!
        let brightness: NSNumber = 0.5
        brightnessFilter.setValue(highlightedImage, forKey: kCIInputImageKey)
        brightnessFilter.setValue(brightness, forKey: kCIInputBrightnessKey)
        
        return brightnessFilter.outputImage!.cropping(to: image.extent)
    }
    
    func applyValencia(image: CIImage) -> CIImage {
        let valenciaFilter = CIFilter(name: PhotoEffectChrome)!
        valenciaFilter.setValue(image, forKey: kCIInputImageKey)
        return valenciaFilter.outputImage!.cropping(to: image.extent)
    }
    
    func applyNashville(image: CIImage) -> CIImage {
        let nashvilleFilter = CIFilter(name: PhotoEffectInstant)!
        nashvilleFilter.setValue(image, forKey: kCIInputImageKey)
        return nashvilleFilter.outputImage!.cropping(to: image.extent)
    }
    
    func applySepia(image: CIImage) -> CIImage {
        let sepiaFilter = CIFilter(name: Sepia)!
        sepiaFilter.setValue(image, forKey: kCIInputImageKey)
        sepiaFilter.setValue(0.7, forKey: kCIInputIntensityKey)
        
        return sepiaFilter.outputImage!.cropping(to: image.extent)
    }
    
    func applyColorClamp(image: CIImage, minComponents: CIVector, maxComponents: CIVector) -> CIImage {
        let colorClampFilter = CIFilter(name: ColorClamp)!
        colorClampFilter.setValue(image, forKey: kCIInputImageKey)
        colorClampFilter.setValue(minComponents, forKey: "inputMinComponents")
        colorClampFilter.setValue(maxComponents, forKey: "inputMaxComponents")
        
        return colorClampFilter.outputImage!.cropping(to: image.extent)
    }
    
//    func thumbnailsForImage(image: CIImage) {
//        var filteredImages = [FSImageFilter: CIImage]()
//        for filter in FSImageFilter.availableFilters {
//            filteredImages[filter] = self.image(image, withFilter: filter)
//        }
//        
//        return filteredImages
//    }
//    
    
    func thumbnailsForImage(image: CIImage) {
        for filter in FSImageFilter.availableFilters {
            filteredImages[filter] = UIImage(ciImage: self.image(image, withFilter: filter))
        }
    }
    
    func image(_ image: CIImage, withFilter filter: FSImageFilter) -> CIImage {
        switch filter {
        case .normal:
            return image
        case .clarendon:
            return applyClarendon(image: image)
        case .gingham:
            return applyGingham(image: image)
        case .moon:
            return applyMoon(image: image)
        case .lark:
            return applyLark(image: image)
        case .valencia:
            return applyValencia(image: image)
        case .nashville:
            return applyNashville(image: image)
        case .sepia:
            return applySepia(image: image)
        case .arden:
            let minComponents = CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2)
            let maxComponents = CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9)
            return applyColorClamp(image: image, minComponents: minComponents, maxComponents: maxComponents)
        case .noah:
            let minComponents = CIVector(x: 0.3, y: 0.1, z: 0.5, w: 0.2)
            let maxComponents = CIVector(x: 0.6, y: 0.5, z: 0.7, w: 0.9)
            return applyColorClamp(image: image, minComponents: minComponents, maxComponents: maxComponents)
        }
    }
}
