//
//  UISearchBar+ext.swift
//  my-vilnius
//
//  Created by Rokas on 02/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let textField = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        textField.textColor = color
    }
    
}
