//
//  UIImage+ext.swift
//  my-vilnius
//
//  Created by Rokas on 25/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ imageUrl: String) {
        image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
            image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let ref = FIRStorage.storage().reference(forURL: imageUrl)
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in 
            if error != nil {
                print("Unable to download image from Firebase storage")
            } else {
                print("Image downloaded from Firebase storage")
                if let imgData = data {
                    if let downloadedImage = UIImage(data: imgData) {
                        self.image = downloadedImage
                        imageCache.setObject(downloadedImage, forKey: imageUrl as NSString)
                    }
                }
            }
        })
    }
    
}
