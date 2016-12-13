//
//  LineView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/12/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class UILineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.4)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
