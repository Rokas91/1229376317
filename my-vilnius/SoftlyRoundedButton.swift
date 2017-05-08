//
//  SoftlyRoundedButton.swift
//  my-vilnius
//
//  Created by Rokas on 26/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class SoftlyRoundedButton: RoundedButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 4
        layer.masksToBounds = true
    }
    
}

