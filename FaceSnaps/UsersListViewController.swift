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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        let userFollowNib = UINib(nibName: "UserFollowCell", bundle: nil)
        tableView.register(userFollowNib, forCellReuseIdentifier: "userFollowCell")
        
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
        
        cell.configure(withDelegate: self)
        
        return cell
    }
}

// MARK: - UserFollowDelegate
extension UsersListViewController: UserFollowDelegate {
    func userForCell(_ cell: UserFollowCell) -> User? {
        guard let index = rowOfCell(cell) else { return nil }
        
        return users[index]
    }
    
    func didTapFollow(action: FollowAction, withCell cell: UserFollowCell) {
        guard let index = rowOfCell(cell) else { return }
        // Make request to either follow or unfollow
        FaceSnapsClient.sharedInstance
        // on success, toggle button
        
    }
    
    private func rowOfCell(_ cell: UITableViewCell) -> Int? {
        guard let indexPath = tableView.indexPath(for: cell) else { return nil }
        let index = indexPath.row
        
        guard index < users.count else { return nil }
        
        return index
    }
}
