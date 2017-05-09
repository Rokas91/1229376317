//
//  MainTabBarController.swift
//  my-vilnius
//
//  Created by Rokas on 03/05/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import SwiftKeychainWrapper
import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties
    
    fileprivate var _shared = AuthService.instance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _shared.delegate = self
        AuthService.validateUser {}
    }

}

// MARK: - Alerting

extension MainTabBarController: Alerting {}

// MARK: - AuthServiceDelegate

extension MainTabBarController: AuthServiceDelegate {
    
    func forceLogOut() {
        createDismissingAlert(title: DELETED_ACCOUNT_MESSAGE, seconds: 10) {
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            try! FIRAuth.auth()?.signOut()
            print("ID removed from keychain \(keychainResult)")
            exit(0)
        }
    }
    
}
