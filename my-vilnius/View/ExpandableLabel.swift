//
//  ExpandableLabel.swift
//  my-vilnius
//
//  Created by Rokas on 26/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class ExpandableLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textColor = .darkGray
        font = .avenir
    }
    
    override func drawText(in rect: CGRect) {
        if let stringText = text, !isTruncated {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
            super.drawText(in: CGRect(x: 0, y: 0, width: self.frame.width, height: ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }

}
