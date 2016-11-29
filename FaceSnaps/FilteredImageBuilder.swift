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

// This class applies the filters to the supplied image
final class FilteredImageBuilder {
    
    // Responsible for holding available filters for application
    private struct PhotoFilter {
        
        // Use static constants to avoid typos throughout application
        static let ColorClamp = "CIColorClamp"
        static let ColorControls = "CIColorControls"
        static let PhotoEffectInstant = "CIPhotoEffectInstant"
        static let PhotoEffectProcess = "CIPhotoEffectProcess"
        static let PhotoEffectNoir = "CIPhotoEffectNoir"
        static let Sepia = "CISepiaTone"
        
        // Return array of default filters
        static func defaultFilters() -> [CIFilter] {
            // MARK: Color Clamp
            let colorClamp = CIFilter(name: PhotoFilter.ColorClamp)!
            // Use KVC to set color clamp key values (min/max components)
            colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
            colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
            
            // MARK: Color Controls
            let colorControls = CIFilter(name: PhotoFilter.ColorControls)!
            // Use KVC to set color controls key value (saturation)
            colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
            
            // MARK: Photo Effects
            let photoEffectInstant = CIFilter(name: PhotoFilter.PhotoEffectInstant)!
            let photoEffectProcess = CIFilter(name: PhotoFilter.PhotoEffectProcess)!
            let photoEffectNoir = CIFilter(name: PhotoFilter.PhotoEffectNoir)!
            
            // MARK: Sepia
            let sepia = CIFilter(name: PhotoFilter.Sepia)!
            // Use KVC to set sepia key value
            sepia.setValue(0.7, forKey: kCIInputIntensityKey)
            
            return [colorClamp, colorControls, photoEffectInstant, photoEffectProcess, photoEffectNoir, sepia]
        }
    }
    
    private let image: UIImage
    private let context: CIContext
    
    init(context: CIContext, image: UIImage) {
        self.image = image
        self.context = context
    }
    
    // Apply default filters to image
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    // Apply filters to image
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.map { image(image: self.image, withFilter: $0) }
    }
    
    // Apply filter to image
    func image(image: UIImage, withFilter filter: CIFilter) -> CIImage {
        // Use nil-colescing operator incase .ciImage returns nil
        let inputImage = image.ciImage ?? CIImage(image: image)!
        
        // Use KVC to set input image for filter
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        let outputImage = filter.outputImage!
        
        return outputImage.cropping(to: inputImage.extent)
    }
}



































