//
//  UITapGestureRecognizer+ext.swift
//  my-vilnius
//
//  Created by Rokas on 30/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    
    private static let annotationAssociation = ObjectAssociation<PhotoAnnotation>()
    private static let imageAssociation = ObjectAssociation<UIImage>()
    
    var annotation: PhotoAnnotation {
        get {
            return UITapGestureRecognizer.annotationAssociation[self]! 
        }
        set {
            UITapGestureRecognizer.annotationAssociation[self] = newValue
        }
    }
    
    var image: UIImage {
        get {
            return UITapGestureRecognizer.imageAssociation[self]! 
        }
        set {
            UITapGestureRecognizer.imageAssociation[self] = newValue
        }
    }
}
