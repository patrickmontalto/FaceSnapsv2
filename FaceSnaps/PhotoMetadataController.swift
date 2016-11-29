//
//  PhotoMetadataController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/3/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoMetadataController: UITableViewController {
    
    let photo: UIImage
    // Image, location, and tags
    let sections = [Section.Image, Section.Location, Section.Tags]
    
    init(photo: UIImage) {
        self.photo = photo
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Metadata fields
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(image: self.photo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var imageViewHeight: CGFloat = {
        // Aspect ratio of the photo: H / W
        let imgAspectRatio = self.photoImageView.frame.size.height / self.photoImageView.frame.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        
        // Calculate the height of the image (cell) based on the screenWidth and aspect ratio
        return screenWidth * imgAspectRatio
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add location"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    // Only init the locationManager if the user taps the row. This avoids unnecessary permission requests.
    var locationManager: LocationManager!
    var location: CLLocation?
    
    lazy var tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "summer, vacation"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoMetadataController.savePhotoWithMetadata))
        navigationItem.rightBarButtonItem = saveButton
    }

}
extension PhotoMetadataController {
    
    // Section id numbers
    struct Section {
        static let Image = 0
        static let Location = 1
        static let Tags = 2
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        // Switch on indexPath to configure cell
        switch (indexPath.section, indexPath.row) {
        case (Section.Image, 0):
            cell.contentView.addSubview(photoImageView)
            
            NSLayoutConstraint.activate([
                photoImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                photoImageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                photoImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                photoImageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
            ])
        case (Section.Location, 0):
            cell.contentView.addSubview(locationLabel)
            cell.contentView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                activityIndicator.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0),
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                locationLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
            ])
        case (Section.Tags, 0):
            cell.contentView.addSubview(tagsTextField)
            
            NSLayoutConstraint.activate([
                tagsTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                tagsTextField.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                tagsTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                tagsTextField.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
            ])
            
            
            
        default: break
        }
        
        return cell
    }
}

// MARK: - Persistence
extension PhotoMetadataController {
    func savePhotoWithMetadata() {
        let tags = tagsFromTextField()
        let _ = Photo.photo(withImage: photo, tags: tags, location: location)
        
        CoreDataController.save()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Helper Methods
extension PhotoMetadataController {
    func tagsFromTextField() -> [String] {
        guard let tags = tagsTextField.text else { return [] }
        
        let commaSeparatedSubSequences = tags.characters.split(separator: ",")
        let commaSeparatedStrings = commaSeparatedSubSequences.map(String.init)
        let lowercaseTags = commaSeparatedStrings.map { $0.lowercased() }
        
        return lowercaseTags.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}

// MARK: - UITableViewDelegate
extension PhotoMetadataController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (Section.Image, 0): return imageViewHeight
        default: return tableView.rowHeight // This has a default value already
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (Section.Location, 0):
            locationLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            locationManager = LocationManager()
            
            // Once we get a location it will call the onLocationFix closure. Assign a closure to that property
            // to capture the location
            locationManager.onLocationFix = { placemark, error in
                if let placemark = placemark {
                    self.location = placemark.location
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.locationLabel.isHidden = false
                    
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                    
                    self.locationLabel.text = "\(name), \(city), \(area)"
                }
            }
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.Image:
            return "Photo"
        case Section.Location:
            return "Enter a location"
        case Section.Tags:
            return "Enter tags"
        default: return nil
        }
    }
}


















