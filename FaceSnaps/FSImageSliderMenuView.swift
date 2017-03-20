//
//  FSImageSliderMenuView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/14/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

protocol FSImageSliderMenuViewDelegate {
    func cancelButtonTapped(type: FSImageAdjustmentType)
    func doneButtonTapped(type: FSImageAdjustmentType)
}

class FSImageSliderMenuView: UIView {
    
    var activeAdjustment: FSImageAdjustmentType?
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        button.setTitle("Done", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var delegate: FSImageSliderMenuViewDelegate!
    
    convenience init(delegate: FSImageSliderMenuViewDelegate) {
        self.init()
        self.delegate = delegate
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        addSubview(cancelButton)
        addSubview(doneButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cancelButtonCenterX = 0.25 * UIScreen.main.bounds.width
        let doneButtonCenterX = 0.75 * UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: cancelButtonCenterX),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        
            doneButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: doneButtonCenterX),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func cancelButtonTapped() {
        delegate.cancelButtonTapped(type: activeAdjustment!)
    }
    func doneButtonTapped() {
        // Hide/unhide active indicator on cell for active slider type if the current value is not it's default value
        delegate.doneButtonTapped(type: activeAdjustment!)
    }
}
