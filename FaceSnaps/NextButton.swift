//
//  NextButton.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/7/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class NextButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 4
        self.setTitle("Next", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 14.0)
        self.setBackgroundColor(color: UIColor(red: 157/255, green: 204/255, blue: 245/255, alpha: 1.0), forUIControlState: .disabled)
        self.setBackgroundColor(color: UIColor(red: 62/255, green: 153/255, blue: 237/255, alpha: 1.0), forUIControlState: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.masksToBounds = true
        
        self.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
