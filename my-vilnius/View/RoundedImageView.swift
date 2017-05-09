//
//  RoundedView.swift
//  my-vilnius
//
//  Created by Rokas on 25/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width / 8
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
}
