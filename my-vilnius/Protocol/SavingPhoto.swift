//
//  SavingPhoto.swift
//  my-vilnius
//
//  Created by Rokas on 26/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import CameraEngine
import UIKit

protocol SavingPhoto: Alerting{}

extension SavingPhoto where Self: UIViewController {
    
    func savePhoto(image: UIImage?) {
        if let image = image {
            CameraEngineFileManager.savePhoto(image, blockCompletion: { (success, error) -> (Void) in
                if success {
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {
                            return 
                        }
                        
                        strongSelf.createDismissingAlert(title: SAVED)
                    }
                }
            })
        }
    }
    
}
