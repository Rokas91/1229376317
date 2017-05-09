//
//  SetDefaultProperties.swift
//  my-vilnius
//
//  Created by Rokas on 02/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol SetDefaultProperties: class {}

// MARK: - UILabel

extension SetDefaultProperties where Self: UILabel {
    
    var defaultFont: UIFont? {
        get { return font }
        set { font = newValue }
    }
    
    var defaultTextColor: UIColor? {
        get { return textColor }
        set { textColor = newValue }
    }
    
}

// MARK: - UITextField

extension SetDefaultProperties where Self: UITextField {
    
    var defaultFont: UIFont? {
        get { return font }
        set { font = newValue }
    }
    
    var defaultTextColor: UIColor? {
        get { return textColor }
        set { textColor = newValue }
    }
    
}

// MARK: - UITextView

extension SetDefaultProperties where Self: UITextView {
    
    var defaultFont: UIFont? {
        get { return font }
        set { font = newValue }
    }
    
    var defaultTextColor: UIColor? {
        get { return textColor }
        set { textColor = newValue }
    }
    
}

// MARK: - UIButton

extension SetDefaultProperties where Self: UIButton {
    
    var defaultFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    var defaultTitleColor: UIColor? {
        get { return titleLabel?.textColor }
        set { titleLabel?.textColor = newValue }
    }
    
}
