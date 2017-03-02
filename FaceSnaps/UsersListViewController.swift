//
//  UsersListViewController.swift
//  FaceSnaps
//
//  Created by Patrick on 2/27/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit


/// Serves as a container for a tableview that will display a list of users.
/// Can be used for liking users, followers, and followed-by users.
class UsersListViewController: UIViewController {
    
    var users = [User]()
    
    lazy var tableView: UITableView = {
        let tblView = UITableView()
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()
    
    // TODO: Add search bar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        automaticallyAdjustsScrollViewInsets = false
        
        let userFollowNib = UINib(nibName: "UserFollowCell", bundle: nil)
        tableView.register(userFollowNib, forCellReuseIdentifier: "userFollowCell")
        
        // Hide FaceSnaps logo
        (navigationController as? HomeNavigationController)?.logoIsHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
        ])
    }
    
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: User Follow Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFollowCell", for: indexPath) as! UserFollowCell
        cell.tag = indexPath.row
        cell.configure(withDelegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserFollowCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileController()
        let user = users[indexPath.row]
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UserFollowDelegate
extension UsersListViewController: UserFollowDelegate {
    func userForCell(_ cell: UserFollowCell) -> User? {
        let index = cell.tag
        
        return users[index]
    }
    
    func didTapFollow(action: FollowAction, withCell cell: UserFollowCell) {
        guard let index = rowOfCell(cell) else { return }
        
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! UserFollowCell
        let user = users[index]
        
        // Make request to either follow or unfollow
        FaceSnapsClient.sharedInstance.modifyRelationship(action: action, user: user) { (result, error) in
            guard let result = result else {
                return
            }
            // Update status for user
            user.incomingStatus = result.rawValue
            
            // Update button
            cell.setFollowButtonText()
            
            // Post notification to reload current user in app
            NotificationCenter.default.post(name: Notification.Name.userProfileUpdatedNotification, object: nil)
        }
    }
    
    private func rowOfCell(_ cell: UITableViewCell) -> Int? {
        guard let indexPath = tableView.indexPath(for: cell) else { return nil }
        let index = indexPath.row
        
        guard index < users.count else { return nil }
        
        return index
    }
}
