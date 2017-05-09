//
//  FirstCameraViewController.swift
//  my-vilnius
//
//  Created by Rokas on 01/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol FirstCameraViewControllerDelegate {
    
    func setImage(image: UIImage)
    
}

class FirstCameraViewController: CameraViewController {
    
    // MARK: - Properties
    
    fileprivate var _firstCameraDelegate: FirstCameraViewControllerDelegate?
    
    fileprivate lazy var _selectButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "select"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectMedia), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _dismissButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "dismiss"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissCamera), for: .touchUpInside)
        
        return button
    }()
    
    var firstCameraDelegate: FirstCameraViewControllerDelegate? {
        get { return _firstCameraDelegate }
        set { _firstCameraDelegate = newValue }
    }

    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
    }
    
}

// MARK: - Selectors

extension FirstCameraViewController {
    
    func selectMedia() {
        if let image = mediaImageView.image {
            _firstCameraDelegate?.setImage(image: image)
        }
        mediaImageView.isHidden = true
        mediaImageView.image = nil
        dismiss(animated: true)
    }
    
    func dismissCamera() {
        dismiss(animated: true)
    }
    
}

// MARK: - CameraDelegate

extension FirstCameraViewController: CameraDelegate {
    
    func setupMediaView() {
        mediaImageView.addSubview(_selectButton)
        
        //x,y,w,h
        _selectButton.rightAnchor.constraint(equalTo: mediaImageView.rightAnchor, constant: -HEIGHT_003).isActive = true
        _selectButton.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: -HEIGHT_003).isActive = true
        _selectButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _selectButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    func setupCameraView(view: UIView) {
        view.addSubview(_dismissButton)
        
        //x,y,w,h
        _dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: HEIGHT_003).isActive = true
        _dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: HEIGHT_0045).isActive = true
        _dismissButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _dismissButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
}






































