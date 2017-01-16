//
//  User.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import IGListKit

class User: IGListDiffable {
    
    let pk: Int
    let name: String
    let userName: String
    let photo: UIImage?
    
    init(pk: Int, name: String, userName: String, photoURLString: String?) {
        self.pk = pk
        self.name = name
        self.userName = userName
        
        guard let photoURLString = photoURLString, let photoURL = URL(string: photoURLString) else {
            self.photo = nil
            return
        }
        
        do {
            let data = try Data(contentsOf: photoURL)
            self.photo = UIImage(data: data)!
        } catch {
            self.photo = nil
        }
    }
    
    // MARK: - IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return pk as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? User else { return false }
        return name == object.name && userName == object.userName
    }
}
