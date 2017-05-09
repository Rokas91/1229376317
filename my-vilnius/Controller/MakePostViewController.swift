//
//  MakePostViewController.swift
//  my-vilnius
//
//  Created by Rokas on 02/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import CoreLocation
import Firebase
import SwiftKeychainWrapper
import UIKit

class MakePostViewController: EditViewController {
    
    // MARK: - Properties
    
    private var _locationManager: CLLocationManager?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        
        _locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
        (UIApplication.shared.delegate as! AppDelegate).delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthService.instance.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            _locationManager?.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _locationManager?.stopUpdatingLocation()
    }
    
}

// MARK: - ApplicationDelegate

extension MakePostViewController: ApplicationDelegate {
    
    func handleAlert() {
        createAlertWithOkAction(title: WRONG_LOCATION_TITLE, message: WRONG_LOCATION_MESSAGE)
    }
    
    func handleError(message: String) {
        createAlertWithOkAction(title: ERROR, message: message)
    }
    
}

// MARK: - EditViewControllerDelegate

extension MakePostViewController: EditViewControllerDelegate {
    
    var charactersCount:Int { 
        return 399
    }
    var leavingWarning: String { 
        return WANT_LEAVE_POSTING
    }
    var buttonTitle: String { 
        return MAKE_POST
    }
    
    func handleTap() {
        (UIApplication.shared.delegate as! AppDelegate).checkLocality {
            AuthService.validateUser {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return 
                    }

                    guard let text = strongSelf.textView.text, !text.isEmpty else {
                        strongSelf.createAlertWithOkAction(title: WARNING, message: MUST_SAY)
                        return
                    }

                    DataService.instance.getCurrentUserData { userData in
                        guard let userData = userData else {
                            strongSelf.createAlertWithOkAction(title: ERROR, message: SOMETHING_WENT_WRONG)
                            return
                        }
                        
                        if let currentUser = AuthService.currentUser {
                            let post: [String: AnyObject] = ["userId" : currentUser.uid as AnyObject,
                                                             "userName" : userData["userName"] as AnyObject,
                                                             "description" : text as AnyObject,
                                                             "timestamp" : FIRServerValue.timestamp() as AnyObject]
                            
                            strongSelf.shared.postsRef.childByAutoId().setValue(post) { (error, reference) in
                                if let _ = error {
                                    strongSelf.createAlertWithOkAction(title: ERROR, message: SOMETHING_WENT_WRONG)
                                } else {
                                    strongSelf.textView.text = ""
                                    strongSelf.dismiss(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - AuthServiceDelegate

extension MakePostViewController: AuthServiceDelegate {
    
    func forceLogOut() {
        createDismissingAlert(title: DELETED_ACCOUNT_MESSAGE, seconds: 10) {
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            try! FIRAuth.auth()?.signOut()
            print("ID removed from keychain \(keychainResult)")
            exit(0)
        }
    }
    
}



