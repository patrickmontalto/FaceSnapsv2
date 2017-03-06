//
//  EditProfileViewController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/19/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    enum EditableItem: String {
        case name = "Name"
        case username = "Username"
        case email = "Email"
        
        func textFieldValue(inTableView tableView: UITableView) -> String? {
            var indexPath: IndexPath

            switch self {
            case .name:
                indexPath = IndexPath(row: 0, section: 0)
            case .username:
                indexPath = IndexPath(row: 1, section: 0)
            case .email:
                indexPath = IndexPath(row: 2, section: 0)
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! EditableTableViewCell
            
            return cell.textField.text
        }
        
        func accessoryImage() -> UIImage? {
            switch self {
            case .name:
                return UIImage(named: "badge_icon")
            case .username:
                return UIImage(named: "user_icon")
            case .email:
                return UIImage(named: "email_icon")
            }
        }
        
        func currentValue() -> String {
            switch self {
            case .name:
                return FaceSnapsDataSource.sharedInstance.currentUser!.name
            case .username:
                return FaceSnapsDataSource.sharedInstance.currentUser!.userName
            case .email:
                return FaceSnapsDataSource.sharedInstance.currentUser!.email
            }
        }
    }
    
    var headerView: EditProfileHeaderView {
        get {
            return self.tableView.headerView(forSection: 0) as! EditProfileHeaderView
        }
    }
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        
        return manager
    }()
    
    lazy var alertController: UIAlertController = {
        return self.createPhotoAlertController(delegate: self, mediaPickerManager: self.mediaPickerManager)
    }()
    
    var editableItems: [EditableItem] = [.name, .username, .email]
    
    lazy var tableView: UITableView = {
        let tblView = UITableView(frame: .zero, style: .grouped)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.delegate = self
        tblView.dataSource = self
        let cellNib = UINib(nibName: "EditableTableViewCell", bundle: nil)
        tblView.register(cellNib, forCellReuseIdentifier: "editableTableViewCell")
        tblView.register(EditProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "editProfileHeaderView")
        tblView.backgroundColor = .backgroundGray
        return tblView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        view.addSubview(tableView)
        automaticallyAdjustsScrollViewInsets = false
        tableView.allowsSelection = false
        
        // Configure navigation bar bar button items
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditingProfile))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
        ])
    }
    
    func finishEditingProfile() {
        // Submit changes to API
        // Get name, username, and email from text fields
        guard let name = EditableItem.name.textFieldValue(inTableView: tableView),
            let username = EditableItem.username.textFieldValue(inTableView: tableView),
            let email = EditableItem.email.textFieldValue(inTableView: tableView) else {
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                displayAlert(withMessage: "Please fill out all fields.", title: "Error", actions: [action])
                return
        }
        
        var editParams = ["user": [ "full_name": name, "username": username, "email": email] ]
        
        if let photo = headerView.userIconView.image {
            let base64String = ImageCoder.encodeToBase64(image: photo)!
            editParams["user"]!["photo"] = "data:image/jpeg;base64,\(base64String)"
        }
        
        FaceSnapsClient.sharedInstance.updateCurrentUserProfile(withAttributes: editParams) { (error) in
            if let error = error {
                _ = APIErrorHandler.handle(error: error, logError: true)
            } else {
                let notification = Notification(name: Notification.Name.userProfileUpdatedNotification)
                NotificationCenter.default.post(notification)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editableTableViewCell", for: indexPath) as! EditableTableViewCell

        let item = editableItems[indexPath.row]
        
        cell.configure(accessoryImage: item.accessoryImage(), placeholder: item.rawValue, currentValue: item.currentValue())

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "editProfileHeaderView") as! EditProfileHeaderView
        view.prepareView(withDelegate: self)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EditProfileHeaderView.height
    }
    
}

// MARK: - EditProfileHeaderViewDelegate
extension EditProfileViewController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        // TODO: Present modal to select or take photo
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MediaPickerManagerDelegate
extension EditProfileViewController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        let compressedImage = UIImage(data: image.jpeg(.low)!)!
        let circleImage = compressedImage.resized(toWidth: view.frame.width)!.circle!
        headerView.update(image: circleImage)
        manager.dismissImagePickerController(animated: true) {}
    }
}

// MARK: - FSImagePickerControllerDelegate
extension EditProfileViewController: FSImagePickerControllerDelegate {
    func imagePickerController(_ picker: FSImagePickerController, didFinishPickingImage image: UIImage) {
        // TODO: Get a reference to the userIconImageView more cleanly. Then set the image
        let circleImage = image.circle!
        headerView.update(image: circleImage)
    }
}
