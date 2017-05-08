//
//  MKAnnotationView+ext.swift
//  my-vilnius
//
//  Created by Rokas on 13/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import MapKit
import UIKit

extension MKAnnotationView {
    
    func loadImageUsingCacheWithUrlString(_ imageUrl: String, completion: @escaping (_ image: UIImage) -> Void) {
        image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
            image = cachedImage.resizeImage(newHeight: 100)
            completion(cachedImage)
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
                        self.image = downloadedImage.resizeImage(newHeight: 100)
                        completion(downloadedImage)
                        imageCache.setObject(downloadedImage, forKey: imageUrl as NSString)
                    }
                }
            }
        })
    }
    
}
