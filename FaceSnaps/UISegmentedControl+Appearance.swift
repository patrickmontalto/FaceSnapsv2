//
//  UISegmentedControl+Appearance.swift
//  FaceSnaps
//
//  Created by Patrick on 2/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    static func customAppearance(forSegmentedControl segmentedControl: UISegmentedControl) {                
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium)], for: .selected)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        let selected = UIImage(named: "segmented_selected")!
        segmentedControl.setBackgroundImage(selected, for: .selected, barMetrics: .default)
    }
}

