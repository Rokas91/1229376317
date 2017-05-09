//
//  UIFont+ext.swift
//  my-vilnius
//
//  Created by Rokas on 04/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

extension UIFont {
    
    static var avenir: UIFont {
        return UIFont(name: "Avenir-Book", size: 17)!
    }
    
    static var avenirHeavy: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 19)!
    }
    
    static func avenir(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Book", size: size)!
    }
    
}
