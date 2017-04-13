//
//  ImageLoader.swift
//  FaceSnaps
//
//  Created by Patrick on 4/13/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    
    // MARK: - Singleton
    static let sharedInstance: ImageLoader = ImageLoader()
    private init() {}
    
    func load(_ urlString: String, fileName: String? = nil, cache: Bool = true, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        // Start background thread for image loading
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Get image data
                let imageData: Data = try Data(contentsOf: url)
                
                // Cache the image if necessary
                if let fileName = fileName, cache {
                    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(fileName).jpg")
                    do {
                        try imageData.write(to: fileURL, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
                guard let image = UIImage(data: imageData) else {
                    print("Unable to convert image data to UIImage")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(image)
                }
                
            } catch {
                print("Unable to obtain imageData from URL")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
        }
        
    }
    
    func loadImageForPost(_ post: FeedItem, cache: Bool, completion: @escaping (UIImage?) -> Void) {
        load(post.photoURLString, fileName: "\(post.pk)", cache: cache) { (image) in
            completion(image)
        }
    }
    
    
}
