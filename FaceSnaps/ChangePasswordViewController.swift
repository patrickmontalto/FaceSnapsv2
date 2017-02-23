//
//  ChangePasswordViewController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/22/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - Properties
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
    
    let rowTitles = [["Current Password"], ["New password", "New password, again"]]
    
    var password: String? {
        get {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EditableTableViewCell
            return cell.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var newPassword: String? {
        get {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! EditableTableViewCell
            return cell.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var newPasswordConf: String? {
        get {
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! EditableTableViewCell
            return cell.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Password"
        
        // Add Done button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishChangingPassword))
    }
    
    func finishChangingPassword() {
        // Check if current password is correct
        guard let password = password, let newPassword = newPassword, let newPasswordConf = newPasswordConf else {
            // TODO: Display Alert: all fields must be filled in
            return
        }
        
        // Check if new passwords match
        guard newPassword == newPasswordConf else {
            // TODO: password and password confirmation do not match.
            return
        }
        // TODO:
        // Submit changes to API
        // If OK, pop view controller
        // API Failure response: present alert to user
        
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ChangePasswordViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editableTableViewCell", for: indexPath) as! EditableTableViewCell
        return cell
    }
    
}
