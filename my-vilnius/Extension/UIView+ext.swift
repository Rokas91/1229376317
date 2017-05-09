//
//  UIView+ext.swift
//  my-vilnius
//
//  Created by Rokas on 28/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

extension UIView {
    
    class func removeClearButton(svs: [UIView]) {
        for sv in svs {
            if let tv = sv as? UITextField, sv.conforms(to: UITextInputTraits.self) {
                tv.clearButtonMode = .never
                return
            } else {
                UIView.removeClearButton(svs: sv.subviews)
            }
        }
    }
    
}
