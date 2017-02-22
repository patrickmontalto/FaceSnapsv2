//
//  EditProfileHeaderView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/19/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

@objc protocol EditProfileHeaderDelegate: class {
    @objc func didTapChangeProfilePhoto()
}

class EditProfileHeaderView: UITableViewHeaderFooterView {
    
    static let height: CGFloat = 150
    
    var delegate: EditProfileHeaderDelegate!
    
    lazy var userIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = FaceSnapsDataSource.sharedInstance.currentUser?.photo?.circle
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var profilePhotoBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Change Profile Photo", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14.0)
        btn.addTarget(self.delegate, action: #selector(EditProfileHeaderDelegate.didTapChangeProfilePhoto), for: .touchUpInside)
        btn.setTitleColor(UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0), for: .normal)
        return btn
    }()
    
    func prepareView(withDelegate delegate: EditProfileHeaderDelegate) {
        self.delegate = delegate
        
        addSubview(userIconView)
        addSubview(profilePhotoBtn)
        
        contentView.backgroundColor = .superLightGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            userIconView.heightAnchor.constraint(equalToConstant: 80),
            userIconView.widthAnchor.constraint(equalToConstant: 80),
            userIconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userIconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            profilePhotoBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profilePhotoBtn.centerYAnchor.constraint(equalTo: userIconView.bottomAnchor, constant: 27)
        ])
    }
    
}
