//
//  LongPressing.swift
//  my-vilnius
//
//  Created by Rokas on 27/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol LongPressing: SavingPhoto {}

extension LongPressing where Self: UIViewController {
    
    func handleLongPress(image: UIImage?, id: String?) {
        let saveAction = UIAlertAction(title: SAVE, style: .default, handler: { action in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                strongSelf.savePhoto(image: image)
            }
        })
        
        let reportAction = UIAlertAction(title: REPORT, style: .default, handler: { action in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                let reportViewController = ReportViewController()
                
                reportViewController.mediaId = id
                strongSelf.present(UINavigationController(rootViewController: reportViewController), animated: true)
            }
        })
        
        let cancelAction = UIAlertAction(title: CANCEL, style: .cancel)
        
        createAlert(title: nil, message: nil, preferredStyle: .actionSheet, actions: saveAction, reportAction, cancelAction)
    }
    
}
