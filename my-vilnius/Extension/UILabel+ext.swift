//
//  UILabel+ext.swift
//  my-vilnius
//
//  Created by Rokas on 25/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

extension UILabel: SetDefaultProperties {
    
    var isTruncated: Bool {
        if let string = self.text {
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude)),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.font],
                context: nil).size
            
            return (size.height > self.bounds.size.height)
        }
        return false
    }
    
}
