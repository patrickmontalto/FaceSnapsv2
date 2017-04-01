//
//  SearchManager.swift
//  FaceSnaps
//
//  Created by Patrick on 2/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class SearchManager: NSObject, UISearchBarDelegate {
    
    // MARK: - Properties
    weak var presentingViewController: UIViewController?
    
    var tableView: UITableView!
    
    var data = [Any]()
    
    var selectedScope = 0
    
    // MARK: - Initializers
    init(searchBar: UISearchBar, tableView: UITableView, presentingViewController: UIViewController) {
        super.init()
        self.tableView = tableView
        self.presentingViewController = presentingViewController
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        tableView.allowsSelectionDuringEditing = true
        
        let nib = UINib(nibName: "UserSearchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "userSearchCell")

    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Make call to API to get search results
        // API Call will either be for Users, Tags, or Locations depending on which is selected
        guard (searchText != "") else {
            self.data = [Any]()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        switch selectedScope {
        case 0:
            // Get users
            getUsers(searchText: searchText)
        case 1:
            // TODO: Get Tags
            break
        case 2:
            // Get locations
            FaceSnapsClient.sharedInstance.getLocations(query: searchText, coordinate: <#T##CLLocationCoordinate2D#>, completionHandler: <#T##([FourSquareLocation]?, APIError?) -> Void#>)
        default:
            break
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO: Handle switching search types
        self.selectedScope = selectedScope
        // Clear data
        self.data = [Any]()
        // Reload tableview
        tableView.reloadData()
    }
    
    // MARK: - Actions
    private func getUsers(searchText: String) {
        FaceSnapsClient.sharedInstance.searchUsers(queryString: searchText, completionHandler: { (usersArray, error) in
            guard let usersArray = usersArray else { return }
            self.data = usersArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    private func getLocations(searchText: String) {
        
    }
    
}

// MARK: - UITableViewDelegate & Data Source
extension SearchManager: UITableViewDelegate, UITableViewDataSource {
    // Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedScope {
        case 0:
            // User search
            guard let userData = data as? [User] else { return UITableViewCell() }
            guard indexPath.row < userData.count else { return UITableViewCell() }
            let user = userData[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "userSearchCell") as! UserSearchCell
            
            cell.user = user
            cell.setContentForUser()
            
            return cell
            
        case 1:
            // Tag search
            return UITableViewCell()
        case 2:
            // Location search
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Present UserProfileController with user at selected row
        presentingViewController?.view.endEditing(true)
        switch selectedScope {
        case 0:
            let vc = ProfileController()
            let user = data[indexPath.row] as! User
            vc.user = user
            presentingViewController?.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        presentingViewController?.view.endEditing(true)
    }
}
