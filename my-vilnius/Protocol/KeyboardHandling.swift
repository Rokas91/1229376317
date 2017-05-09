//
//  KeyboardHandling.swift
//  my-vilnius
//
//  Created by Rokas on 05/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

@objc protocol KeyboardHandling {
    
    func keyboardIsOn(keyboardSize: CGSize)
    func keyboardIsOff()
    
}

private extension UIViewController {
    
    @objc func keyboardIsOn(_ sender: Notification) {
        guard let keyboardHandlingSelf = self as? KeyboardHandling else {
            return
        }
        
        let info = sender.userInfo! as NSDictionary
        let value = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize = value.cgRectValue.size

        keyboardHandlingSelf.keyboardIsOn(keyboardSize: keyboardSize)
    }
    
}

extension KeyboardHandling where Self: UIViewController {
    func registerForKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardIsOn(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardIsOff), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}




















