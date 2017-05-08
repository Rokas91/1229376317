//
//  Alerting.swift
//  my-vilnius
//
//  Created by Rokas on 04/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol Alerting {}

extension Alerting where Self: UIViewController {
    
    func createAlert(title: String?, message: String?, preferredStyle: UIAlertControllerStyle? = .alert, actions: UIAlertAction...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
    func createAlertWithOkAction(title: String, message: String? = nil, handler: ((UIAlertAction) -> ())? = nil) {
        let okAction = UIAlertAction(title: OK, style: .default, handler: handler)
        
        createAlert(title: title, message: message, actions: okAction)
    }
    
    func createDismissingAlert(title: String, seconds: Double? = 2, action: (() -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds!) {
            alertController.dismiss(animated: true)
            if let action = action {
                action()
            }
        }
    }
    
}
