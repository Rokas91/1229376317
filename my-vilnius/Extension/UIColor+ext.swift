//
//  UIColor+ext.swift
//  my-vilnius
//
//  Created by Rokas on 27/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var customGreen: UIColor {
        return UIColor(r: 0, g: 150, b: 136)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
