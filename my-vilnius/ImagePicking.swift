//
//  ImagePicking.swift
//  my-vilnius
//
//  Created by Rokas on 06/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol ImagePicking: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setImage(image: UIImage)
    func handleSelectedImageView() 
    
}

extension ImagePicking where Self: UIViewController {
    
    func createImagePicker() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(image: UIImage) {
        setImage(image: image)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel() {
        dismiss(animated: true)
    }
    
}
