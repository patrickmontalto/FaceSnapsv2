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
        
        self.automaticallyAdjustsScrollViewInsets = false

        view.addSubview(tableView)
        
        title = "Password"
        view.backgroundColor = .white

        // Add Done button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishChangingPassword))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
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
        let editParams = ["password": password, "new_password": newPassword]

        // Submit changes to API
        FaceSnapsClient.sharedInstance.changeUserPassword(params: editParams, completionHandler: { (error) in
            if let error = error {
                let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                APIErrorHandler.handle(error: error, withActions: [action], presentingViewController: self)
            } else {
                // TODO: Dropdown - password changed
                let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                self.displayAlert(withMessage: "", title: "Password successfully updated.", actions: [action])
            }
        })
        
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ChangePasswordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editableTableViewCell", for: indexPath) as! EditableTableViewCell
        
        let placeholder = rowTitles[indexPath.section][indexPath.row]
        let lockImage = UIImage(named: "lock-icon")
        cell.configure(accessoryImage: lockImage, placeholder: placeholder, currentValue: nil)
        cell.textField.isSecureTextEntry = true
        cell.textField.clearButtonMode = .whileEditing
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
