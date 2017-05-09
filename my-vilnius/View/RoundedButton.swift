//
//  RoundedButton.swift
//  my-vilnius
//
//  Created by Rokas on 05/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        showsTouchWhenHighlighted = true
    }
    
    private func setupUI() {
        layer.backgroundColor = UIColor.customGreen.cgColor
        titleLabel?.font = .avenir
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }
    
}
