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
    
    var location: FourSquareLocation? {
        didSet {
            self.postTableView.reloadData()
        }
    }
    
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
    
    lazy var backgroundDimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    lazy var postTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(PostHeaderView.self, forHeaderFooterViewReuseIdentifier: PostHeaderView.reuseIdentifier)
        tv.backgroundColor = .backgroundGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var thumbnailAnimator: ThumbnailAnimator?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constant.defaultTitle
        
        view.addSubview(postTableView)
        view.addSubview(backgroundDimmingView)
        automaticallyAdjustsScrollViewInsets = false
        
        setShareButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let thumbnail = (postTableView.headerView(forSection: 0) as! PostHeaderView).thumbnail()
        thumbnailAnimator = ThumbnailAnimator(thumbnail: thumbnail, viewController: self)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Constraints
        
        NSLayoutConstraint.activate([
            postTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            postTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            postTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundDimmingView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: PostHeaderView.height),
            backgroundDimmingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundDimmingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundDimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    // MARK: - Methods
    
    // TODO: Configure method to submit post
    @objc private func submitPost() {
        
    }
    
    @objc private func confirmCaption() {
        view.endEditing(true)
    }
    
    @objc private func presentLocationPicker() {
        let locationPicker = LocationPickerController(delegate: self)
        let locationPickerNav = UINavigationController(rootViewController: locationPicker)
        present(locationPickerNav, animated: true, completion: nil)
    }
    
    // MARK: - Updating UI
    fileprivate func setShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(submitPost))
        navigationItem.rightBarButtonItem?.tintColor = .buttonBlue
    }
    
    fileprivate func setCaptionButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(confirmCaption))
        navigationItem.rightBarButtonItem?.tintColor = .buttonBlue
    }
}

// MARK: - LocationPickerDelegate
extension CreatePostController: LocationPickerDelegate {
    func locationPicker(_ picker: LocationPickerController, didSelectLocation location: FourSquareLocation) {
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
        var cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if let location = location {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = location.name
            // TODO: Correct detail text label text from API
            cell.detailTextLabel?.text = location.detailString
            let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            cancelButton.setImage(#imageLiteral(resourceName: "cancel_button"), for: .normal)
            cancelButton.addTarget(self, action: #selector(resetLocation), for: .touchUpInside)
            cell.accessoryView = cancelButton
            cell.imageView?.image = #imageLiteral(resourceName: "location")
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
    
    @objc private func resetLocation() {
        location = nil
    }
}
// MARK: - PostHeaderViewDelegate & UITextFieldDelegate
extension CreatePostController: UITextViewDelegate, PostHeaderViewDelegate {
    func imageForPost() -> UIImage {
        return self.image
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a caption..." {
            textView.text = nil
        }
        textView.textColor = .black
        title = Constant.captionTitle
        setCaptionButton()
        UIView.animate(withDuration: 0.1) {
            self.backgroundDimmingView.alpha = 0.7
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption..."
            textView.textColor = .lightGray
        }
        title = Constant.defaultTitle
        setShareButton()
        UIView.animate(withDuration: 0.1) {
            self.backgroundDimmingView.alpha = 0
        }
    }
}
