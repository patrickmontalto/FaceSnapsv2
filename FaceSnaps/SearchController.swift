//
//  SearchController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = .white
        // Set textfield color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .mediumLightGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .gray
        let segmentedControl = UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        UISegmentedControl.customAppearance(forSegmentedControl: segmentedControl)

        sb.showsScopeBar = true
        sb.scopeButtonTitles = ["People", "Tags", "Places"]
        
        return sb
    }()
    
    lazy var resultsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var searchManager: SearchManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchManager = SearchManager(searchBar: searchBar, tableView: resultsTableView, presentingViewController: self)
        
        view.addSubview(searchBar)
        view.addSubview(resultsTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar
        navigationController?.navigationBar.isHidden = true
        view.endEditing(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
        ])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Unhide navigation bar
        navigationController?.navigationBar.isHidden = false
    }
}

