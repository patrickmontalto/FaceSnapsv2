//
//  FSImageAdjustmentType.swift
//  FaceSnaps
//
//  Created by Patrick on 3/17/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import Foundation

typealias FilterValue = (NSNumber, NSNumber?)

/// Equatable function implementation for FilterValue tuples
func == <T:Equatable> (tuple1:(T,T?),tuple2:(T,T?)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}

enum FSImageAdjustmentType: Int {
    case brightness, contrast, structure, warmth, saturation, highlights, shadows, vignette, tiltshift
    
    var stringRepresentation: String {
        switch self {
        case .brightness:
            return "Brightness"
        case .contrast:
            return "Contrast"
        case .structure:
            return "Structure"
        case .warmth:
            return "Warmth"
        case .saturation:
            return "Saturation"
        case .highlights:
            return "Highlights"
        case .shadows:
            return "Shadows"
        case .vignette:
            return "Vignette"
        case .tiltshift:
            return "Tilt Shift"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .brightness:
            return UIImage(named: "brightness_icon")!
        case .contrast:
            return UIImage(named: "contrast_icon")!
        case .structure:
            return UIImage(named: "structure_icon")!
        case .warmth:
            return UIImage(named: "warmth_icon")!
        case .saturation:
            return UIImage(named: "structure_icon")!
        case .highlights:
            return UIImage(named: "highlights_icon")!
        case .shadows:
            return UIImage(named: "shadows_icon")!
        case .vignette:
            return UIImage(named: "vignette_icon")!
        case .tiltshift:
            return UIImage(named: "tiltshift_icon")!
        }
    }
    
    var defaultValue: Float {
        return 0

//        switch self {
//        case .brightness:
//            return (0.0, nil)
//        case .contrast:
//            return (1.0, nil)
//        case .structure:
//            return (1.0, 0.0)
//        case .warmth:
//            return (6500.0, nil)
//        case .saturation:
//            return (1.0, nil)
//        case .highlights:
//            return (1.0, nil)
//        case .shadows:
//            return (1.0, nil)
//        case .vignette:
//            return (1.0, 0.0)
//        case .tiltshift:
//            return (0, nil)
//        }
    }
}
