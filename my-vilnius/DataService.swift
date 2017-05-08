//
//  DataService.swift
//  my-vilnius
//
//  Created by Rokas on 26/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase

class DataService {
    
    private static let _instance = DataService()
    private var _posts: [Post] = []
    private var _mediaArray: [Media] = []
    
    static var instance: DataService {
        return _instance
    }
    
    var posts: [Post] {
        get {
            return _posts
        } set {
            _posts = newValue
        }
    }
    
    var mediaArray: [Media] {
        get {
            return _mediaArray
        } set {
            _mediaArray = newValue
        }
    }
    
    // MARK: - DB references
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var postsRef: FIRDatabaseReference {
        return mainRef.child(FIR_POSTS)
    }
    
    var mediaRef: FIRDatabaseReference {
        return mainRef.child(FIR_MEDIA)
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child(FIR_USERS)
    }
    
    var currentUserRef: FIRDatabaseReference? {
        if let currentUser = AuthService.currentUser {
            return mainRef.child(FIR_USERS).child(currentUser.uid)
        }
        return nil
    }
    
    var reportsRef: FIRDatabaseReference {
        return mainRef.child(FIR_REPORTS)
    }
    
    // MARK: - Storage references
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    var mediaStorageRef: FIRStorageReference {
        return mainStorageRef.child(FIR_MEDIA)
    }
    
    var usersStorageRef: FIRStorageReference {
        return mainStorageRef.child(FIR_USERS)
    }
    
    // MARK: - Observers
    
    func observePosts(completion: @escaping () -> ()) {
        postsRef.observe(.childAdded , with: { snapshot in 
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                if let postData = snapshot.value as? [String : AnyObject] {
                    strongSelf._posts.insert(Post(postId: snapshot.key, postData: postData), at: 0)
                }
                completion()
            }
        })
        
        postsRef.observe(.childRemoved , with: { snapshot in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                if let postData = snapshot.value as? [String : AnyObject] {
                    let post = Post(postId: snapshot.key, postData: postData)
                    strongSelf._posts = strongSelf._posts.filter { $0.postDesc != post.postDesc && $0.timestamp != post.timestamp }
                }
                completion()
            }
        })
    }
    
    func observeMedia(completion: @escaping () -> ()) {
        mediaRef.observe(.childAdded, with: { snapshot in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                if let mediaData = snapshot.value as? [String : AnyObject] {
                    strongSelf._mediaArray.append(Media(mediaId: snapshot.key, mediaData: mediaData))
                }
                completion()
            }
        })
        
        mediaRef.observe(.childRemoved, with: { snapshot in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                if let mediaData = snapshot.value as? [String : AnyObject] {
                    strongSelf._mediaArray = strongSelf._mediaArray.filter { $0.imageUrl != Media(mediaId: snapshot.key, mediaData: mediaData).imageUrl }
                }
                completion()
            }
        })
    }
    
    func observeAnnotations(addAnnotation: @escaping (_ annotation: PhotoAnnotation) -> (), removeAnnotation: @escaping (_ annotation: PhotoAnnotation) -> ()) {
        mediaRef.observe(.childAdded, with: { snapshot in 
            if let mediaData = snapshot.value as? [String : AnyObject] {
                addAnnotation(PhotoAnnotation(annotationId: snapshot.key, annotationData: mediaData))
            }
        })
        
        mediaRef.observe(.childRemoved, with: { snapshot in
            if let mediaData = snapshot.value as? [String : AnyObject] {
                removeAnnotation(PhotoAnnotation(annotationId: snapshot.key, annotationData: mediaData))
            }
        })
    }
    
    // MARK: - SingleEvent snapshots
    
    func getUserData(userId: String, completion: @escaping (_ userData: [String : AnyObject]?) -> ()) {
        usersRef.child(userId).observeSingleEvent(of: .value , with: { snapshot in
            if let userData = snapshot.value as? [String : AnyObject] {
                completion(userData)
            } else {
                completion(nil)
            }
        })
    }
    
    func getCurrentUserData(completion: @escaping (_ userData: [String : AnyObject]?) -> ()) {
        if let currentUserRef = currentUserRef {
            currentUserRef.observeSingleEvent(of: .value , with: { snapshot in
                if let userData = snapshot.value as? [String : AnyObject] {
                    completion(userData)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
}
