//
//  CircleView.swift
//  my-vilnius
//
//  Created by Rokas on 08/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
}
