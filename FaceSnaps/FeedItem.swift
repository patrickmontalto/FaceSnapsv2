//
//  FeedItem.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import IGListKit
import RealmSwift

final class FeedItem: Object, IGListDiffable {
    
    dynamic var pk: Int = 0
    dynamic var user: User?
    dynamic var caption: String = ""
    var comments = List<Comment>()
    dynamic var photoData: Data? = nil
    dynamic var liked: Bool = false
    dynamic var likesCount: Int = 0
    dynamic var datePosted: Date = Date()
    var photoURLString: String = ""
    
    convenience init(pk: Int, user: User, caption: String, comments: List<Comment>, photoURLString: String, liked: Bool, datePosted: Date, likesCount: Int) {
        self.init()
        
        self.pk = pk
        self.user = user
        self.caption = caption
        self.comments = comments
        self.liked = liked
        self.likesCount = likesCount
        self.datePosted = datePosted
        
        // Return if invalid URL string
        guard let _ = URL(string: photoURLString) else {
            return
        }
        
        self.photoURLString = photoURLString
        
    }
    
    
    // Set imageView on cell to this property. If the property is null,
    // then begin background request to URL
    var photo: UIImage? {
        get {
            let photoPathString = (FaceSnapsDataSource.sharedInstance.directoryPath() as NSString).appendingPathComponent("\(pk).jpg")
            if FaceSnapsDataSource.sharedInstance.fileManager.fileExists(atPath: photoPathString) {
                print("File exists!")
            }
            return UIImage(contentsOfFile: photoPathString)
        }
    }
    
    // Background request for UIImage from URL String
    func photoFromURL(cache: Bool, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        let url = URL(string: photoURLString)!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completionHandler(nil)
                return
            }
            // TODO: Old implementation of caching to documents dir
            if cache {
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(self.pk).jpg")
               // var path = FaceSnapsDataSource.sharedInstance.directoryPath() as NSString
               // path.appendingPathComponent("\(self.pk).jpg")

               // let imageData = UIImageJPEGRepresentation(image, 0.5)
               // let success = FaceSnapsDataSource.sharedInstance.fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
               // print(success)
                do {
                    try data.write(to: fileURL, options: .atomic)
                } catch {
                    print(error)
                }
            }
            completionHandler(image)
        }
        
        dataTask.resume()
    }
    
    // MARK: - IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return pk as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? FeedItem else { return false }
        return user!.isEqual(toDiffableObject: object.user) //&& comments == object.comments
    }
    
}
