//
//  SearchManager.swift
//  FaceSnaps
//
//  Created by Patrick on 2/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class SearchManager: NSObject, UISearchBarDelegate, LocationManagerObserver {
    
    enum SearchScope: Int {
        case user, tag, location
        
        var placeholder: String {
            switch self {
            case .user:
                return "Search users"
            case .tag:
                return "Search hashtags"
            case .location:
                return "Search locations"
            }
        }
        
    }
    
    // MARK: - Properties
    weak var presentingViewController: UIViewController?
    
    fileprivate var tableView: UITableView!
    
    fileprivate var data = [Any]()
    
    fileprivate var selectedScope = 0
    
    fileprivate var searchBar: UISearchBar!
    
    fileprivate var emptyTableText: String?
    
    private var locationSearcher: LocationSearcher!
    
    // MARK: - Initializers
    init(searchBar: UISearchBar, tableView: UITableView, presentingViewController: UIViewController) {
        super.init()
        self.searchBar = searchBar
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        
        self.locationSearcher = LocationSearcher()
        
        subscribeToLocationNotifications()
    }
    
    deinit {
        unsubscribeToLocationNotifications()
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
            getTags(searchText: searchText)
        case 2:
            // Get locations
            getLocations(searchText: searchText)
        default:
            break
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scope = SearchScope(rawValue: selectedScope) else { return }
        // Handle switching search types
        self.selectedScope = selectedScope
        // Clear data
        self.data.removeAll()
        // Reload tableview
        tableView.reloadData()
        // Change placeholder text
        searchBar.placeholder = scope.placeholder
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
    
    private func getTags(searchText: String) {
        // Clear Data
        self.data.removeAll()
        
        FaceSnapsClient.sharedInstance.searchTags(queryString: searchText, completionHandler: {(tags, error) in
            guard let tags = tags else { return }
            self.data = tags
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    private func getLocations(searchText: String) {
        // Clear data
        self.data.removeAll()
        
        locationSearcher.getLocationsForQuery(query: searchText) { (result) in
            if let locations = result.0 {
                self.data = locations
            } else if let locationError = result.1 {
                self.emptyTableText = locationError.cellText
            } else {
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Notifications
    func locationDidUpdate() {
        getLocations(searchText: searchBar.text ?? "")
    }
    
    func locationDidFail() {
        emptyTableText = LocationError.unlocatable.cellText
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
            guard let tagData = data as? [Tag] else { return UITableViewCell() }
            guard indexPath.row < tagData.count else { return UITableViewCell() }
            let tag = tagData[indexPath.row]
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: String.init(describing: UITableViewCell.self))
            cell.textLabel?.text = "#\(tag.name)"
            

            cell.detailTextLabel?.text = "\(tag.postsCount) \(tag.postsCount == 1 ? "post" : "posts")"
            
            return cell
        case 2:
            // Location search
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
            cell.textLabel?.textColor = .black
        
            if data.count == 0 {
                cell.textLabel?.text = emptyTableText
                return cell
            }
            
            guard let locationData = data as? [FourSquareLocation] else { return UITableViewCell() }
            
            guard indexPath.row < locationData.count else { return UITableViewCell() }
            
            let location = locationData[indexPath.row]
        
            cell.textLabel?.text = location.name
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedScope == 0 {
            return 70.0
        } else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Present UserProfileController with user at selected row
        presentingViewController?.view.endEditing(true)
        switch selectedScope {
        case 0:
            // User
            let vc = ProfileController()
            let user = data[indexPath.row] as! User
            vc.user = user
            presentingViewController?.navigationController?.pushViewController(vc, animated: true)
        case 1:
            // Tag
            let tag = data[indexPath.row] as! Tag
            let vc = TagPostsController(tag: tag)
            presentingViewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            // Location
            let location = data[indexPath.row] as! FourSquareLocation
            let vc = LocationPostsController(location: location)
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
