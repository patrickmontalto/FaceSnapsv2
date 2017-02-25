//
//  UserOptionsViewController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/18/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class UserOptionsViewController: UIViewController {
    
    // MARK: - Properties
    enum SectionTitle: String {
        case account = "Account"
        case about = "About"
        case blank = " "
    }
    
    enum OptionsItem: String {
        case editProfile = "Edit Profile"
        case changePassword = "Change Password"
        case postsLiked = "Posts You've Liked"
        case privateAccount = "Private Account"
        case privacyPolicy = "Privacy Policy"
        case openSourceLibraries = "Open Source Libraries"
        case logOut = "Log Out"
    }
    
    var user: User!
    
    lazy var optionsTableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.delegate = self
        tblView.dataSource = self
        return tblView
    }()
    
    let sectionTitles: [SectionTitle] = [.account, .about, .blank]
    let optionsItems: [[OptionsItem]] = [[.editProfile,.changePassword,.postsLiked,.privateAccount],
                                        [.privacyPolicy, .openSourceLibraries],
                                        [.logOut]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        
        view.addSubview(optionsTableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Set view title
        title = "Options"
        
        // Constraints
        NSLayoutConstraint.activate([
            optionsTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            optionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            optionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            optionsTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension UserOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Acount, About, Actions (Log Out)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section <= optionsItems.count else { return 0 }
        return optionsItems[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section <= sectionTitles.count else { return nil }
        return sectionTitles[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "optionsCell")
        // set cell text label
        cell.textLabel?.text = optionsItems[indexPath.section][indexPath.row].rawValue
        // set cell accessory type
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0 && indexPath.row == 3 {
//            cell.accessoryView
            // TODO: set cell's accessory view to a toggle switch for privacy (PUT edit to user profile: private: true )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section <= sectionTitles.count else { return }
        
        let selectedItem = optionsItems[indexPath.section][indexPath.row]
        
        actionForItem(item: selectedItem)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Returns the view controller for the particular option item selected
    private func actionForItem(item: OptionsItem) {
        switch item {
        case .editProfile:
            // Present Edit Profile VC
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .changePassword:
            // TODO: Present change password VC
            let vc = ChangePasswordViewController()
            navigationController?.pushViewController(vc, animated: true)
            break
        case .postsLiked:
            // TODO: Present Posts Liked VC
            // style individual
            // style thumbnails
            // style feed
            let vc = PostsCollectionViewContainer(style: .thumbnails, dataSource: .postsLiked)
            vc.title = "Liked Posts"
            navigationController?.pushViewController(vc, animated: true)
            break
        case .privateAccount:
            // TODO: Toggle switch
            break
        case .privacyPolicy:
            // TODO: Present Privacy Policy
            break
        case .openSourceLibraries:
            // TODO: Present OSL VC
            break
        case .logOut:
            // TODO: Present UIAlert for log out
            let logOut = UIAlertAction(title: "Log Out", style: .default, handler: { (action) in
                // Log out user
                FaceSnapsDataSource.sharedInstance.logOutCurrentUser()
                // Go back to LoginFlowNav controller
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            displayAlert(withMessage: "", title: "Log Out of FaceSnaps?", actions: [cancel, logOut])
            break
        }
        

    }
    
}
