//
//  CreatePostController.swift
//  FaceSnaps
//
//  Created by Patrick on 3/21/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import Foundation

class CreatePostController: UIViewController {
    
    enum Constant {
        static let defaultTitle = "New Post"
        static let captionTitle = "Caption"
    }
    
    // MARK: - Properties

    var image: UIImage!
    
    var location: FourSquareLocation?
    
    var captionText: String? {
        let postHeaderView = postTableView.headerView(forSection: 0) as! PostHeaderView
        return postHeaderView.captionText
    }
    
    // TODO: Create LocationPicker
//    lazy var locationPicker: LocationPickerController = {
//        let picker = LocationPickerController(delegate: self)
//        return picker
//    }()
    
    lazy var postTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(PostHeaderView.self, forHeaderFooterViewReuseIdentifier: PostHeaderView.reuseIdentifier)
        tv.backgroundColor = .backgroundGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constant.defaultTitle
        
        view.addSubview(postTableView)
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(submitPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Constraints
        
        NSLayoutConstraint.activate([
            postTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            postTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            postTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Methods
    
    // TODO: Configure method to submit post
    func submitPost() {
        
    }
    
    // TODO: Implement location picker
    func presentLocationPicker() {
        let locationPicker = LocationPickerController(delegate: self)
        let locationPickerNav = UINavigationController(rootViewController: locationPicker)
        present(locationPickerNav, animated: true, completion: nil)
        // LocationPicker will have a locationManager property
        // locationPicker will have a a delegate property: LocationPickerDelegate!
        // locationPicker will notify the delegate once a location is picked:
        // locationPicker(_ locationPicker: LocationPicker, didFinishPickingLocation: (Location))
    }
}

// MARK: - LocationPickerDelegate
extension CreatePostController: LocationPickerDelegate {
    func locationPicker(_ picker: LocationPickerController, didSelectLocation location: FourSquareLocation) {
        // TODO
        picker.dismiss(animated: true, completion: nil)
        self.location = location
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CreatePostController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: create cell with left accesosry image
        // TODO: Create cell with horizontal scrolling view of locations
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostHeaderView.reuseIdentifier) as! PostHeaderView
        view.prepareView(withDelegate: self)
        return view
    }
}
// MARK: - PostHeaderViewDelegate & UITextFieldDelegate
extension CreatePostController: UITextFieldDelegate, PostHeaderViewDelegate {
    func imageForPost() -> UIImage {
        return self.image
    }
    
    func tappedThumbnail() {
        // TODO: Animate presenting the image full screen, dim the background
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: Dim the rest of the view, change the title to "Caption"
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Reset the display, change title back to "New Post"
    }
}
