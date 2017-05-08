//
//  AuthService.swift
//  my-vilnius
//
//  Created by Rokas on 05/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import UIKit

typealias Completion = (_ errMsg: String?, _ data: FIRUser?) -> ()

@objc protocol AuthServiceDelegate {
    
    @objc optional func handleSendingError(email: String?)
    @objc optional func handleSentEmailVerification(email: String?)
    @objc optional func handleNotVerifiedEmail(email: String?)
    @objc optional func handleSetValueError()
    @objc optional func forceLogOut()
    
}

class AuthService {
    
    private static let _instance = AuthService()
    
    private var _delegate: AuthServiceDelegate?
    
    static var instance: AuthService {
        return _instance
    }
    
    static var currentUser: FIRUser? {
        return FIRAuth.auth()?.currentUser
    }
    
    var delegate: AuthServiceDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    static func validateUser(completion: @escaping () -> ()) {
        FIRAuth.auth()?.currentUser?.getTokenForcingRefresh(true, completion: { (idToken, error) in
            guard error == nil else {
                if let errorCode = FIRAuthErrorCode(rawValue: (error! as NSError).code) {
                    switch errorCode {
                    case .errorCodeUserNotFound:
                        _instance._delegate?.forceLogOut?()
                        break
                    case .errorCodeUserDisabled:
                        _instance._delegate?.forceLogOut?()                        
                        break
                    default:
                        break
                    }
                }
                return
            }
            
            completion()
        })
    }
    
    func login(email: String, password: String, onComplete: @escaping Completion) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                if error != nil {
                    strongSelf.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                } else if let user = user {
                    if user.isEmailVerified {
                        onComplete(nil, user)
                    } else {
                        strongSelf._delegate?.handleNotVerifiedEmail?(email: user.email)
                    }
                }
            }
        })
    }
    
    func createUser(userName: String, email: String, password: String, profileImage: UIImage, onComplete: @escaping Completion) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return 
                }
                
                if error != nil {
                    strongSelf.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                } else if let user = user {
                    user.sendEmailVerification { error in
                        if error != nil {
                            strongSelf._delegate?.handleSendingError?(email: user.email)
                        } else {
                            strongSelf._delegate?.handleSentEmailVerification?(email: user.email)
                            strongSelf.saveUser(uid: user.uid, userName: userName as AnyObject, email: email as AnyObject, profileImage: profileImage)
                        }
                    }
                }
            }
        })
    }
    
    func saveUser(uid: String, userName: AnyObject, email: AnyObject, profileImage: UIImage) {
        let profile: [String : AnyObject] = [
            "userName" : userName,
            "email" : email
        ]
        
        DataService.instance.usersRef.child(uid).setValue(profile) { (error, reference) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                if let _ = error {
                    strongSelf._delegate?.handleSetValueError?()
                } else {
                    strongSelf.postToStorage(image: profileImage, storageRef: DataService.instance.usersStorageRef, uid: uid)
                }
            }
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion) {
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .errorCodeInvalidEmail:
                onComplete(INVALID_EMAIL_ERROR, nil)
                break
            case .errorCodeWrongPassword:
                onComplete(INVALID_PASSWORD, nil)
                break
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete(ACCOUNT_EXITSTS_ERROR, nil)
                break
            case .errorCodeWeakPassword:
                onComplete(WEAK_PASSWORD_ERROR, nil)
                break
            default:
                onComplete(AUTHENTICATION_DEFAULT_ERROR, nil)
                break
            }
        }
    }
    
}

extension AuthService: ImageUploading {
    
    func postToDB(imageUrl: String, uid: String) {
        DataService.instance.usersRef.child(uid).updateChildValues(["imageUrl" : imageUrl as AnyObject])
    }
    
}
