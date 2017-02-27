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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: User Follow Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        return cell
    }
}
