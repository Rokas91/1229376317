//
//  ImageUploading.swift
//  my-vilnius
//
//  Created by Rokas on 12/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase

protocol ImageUploading {
    
    func postToDB(imageUrl: String, uid: String)
    
}

extension ImageUploading {
    
    func postToStorage(image: UIImage, storageRef: FIRStorageReference, uid: String) {
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.child(uid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Unable to upload to Firebase storage")
                } else {
                    print("Successfully uploaded image to Firebase storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToDB(imageUrl: url, uid: uid)
                    }
                }
            }
        }
    }
    
}
