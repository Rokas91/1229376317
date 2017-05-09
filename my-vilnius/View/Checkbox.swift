//
//  Checkbox.swift
//  my-vilnius
//
//  Created by Rokas on 28/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol CheckboxDelegate {
    
    func check()
    func unCheck()
    
}

class Checkbox: UIButton {
    
    private var _delegate: CheckboxDelegate?
    
    private lazy var _checkedImg: UIImage = {
        return UIImage(named: "checked_checkbox")
    }()!
    
    private lazy var _unCheckedImg: UIImage = {
        return UIImage(named: "unchecked_checkbox")
    }()!
    
    var delegate: CheckboxDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                setImage(_checkedImg, for: .normal)
            } else {
                setImage(_unCheckedImg, for: .normal)
            }
        }
    }
    
    func checkboxTapped() {
        if isChecked {
            isChecked = false
            _delegate?.unCheck()
        } else {
            isChecked = true
            _delegate?.check()
        }
    }
    
}
