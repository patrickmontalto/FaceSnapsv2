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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var locationPicker: LocationPickerCoordinator = {
        let picker = LocationPickerCoordinator(locationPickerDelegate: self)
        return picker
    }()
    
    lazy var postTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(PostHeaderView.self, forHeaderFooterViewReuseIdentifier: PostHeaderView.reuseIdentifier)
        tv.backgroundColor = .backgroundGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        self.location = location
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CreatePostController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: create cell with left accesosry image
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if let location = location {
            cell.textLabel?.text = location.name
        } else {
            cell.textLabel?.text = "Add Location"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostHeaderView.reuseIdentifier) as! PostHeaderView
            view.prepareView(withDelegate: self)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present location picker
        tableView.deselectRow(at: indexPath, animated: true)
        present(locationPicker, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return PostHeaderView.height
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
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
