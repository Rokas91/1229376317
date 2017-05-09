//
//  SecondCameraViewController.swift
//  my-vilnius
//
//  Created by Rokas on 01/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import CoreLocation
import Firebase
import UIKit

class SecondCameraViewController: CameraViewController {
    
    // MARK: - Properties
    
    fileprivate var _locationManager: CLLocationManager?
    fileprivate let _shared = DataService.instance
    
    fileprivate lazy var _sendButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "send"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendMedia), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _checkbox: Checkbox = {
        let button = Checkbox()
        
        button.delegate = self
        
        return button
    }()
    
    fileprivate lazy var _checkboxLabel: UILabel = {
        let label = UILabel()
        
        label.text = SHOW
        label.textColor = .customGreen
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            _locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
            _locationManager?.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _locationManager?.stopUpdatingLocation()
    }
    
}

// MARK: - SetupUI

extension SecondCameraViewController {
    
    fileprivate func setupSendButton() {
        mediaImageView.addSubview(_sendButton)
        
        //x,y,w,h
        _sendButton.rightAnchor.constraint(equalTo: mediaImageView.rightAnchor, constant: -HEIGHT_003).isActive = true
        _sendButton.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: -HEIGHT_003).isActive = true
        _sendButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _sendButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    fileprivate func setupCheckbox() {
        mediaImageView.addSubview(_checkbox)
        
        //x,y,w,h
        _checkbox.rightAnchor.constraint(equalTo: mediaImageView.rightAnchor, constant: -HEIGHT_003).isActive = true
        _checkbox.topAnchor.constraint(equalTo: mediaImageView.topAnchor, constant: HEIGHT_006).isActive = true
        _checkbox.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _checkbox.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    fileprivate func setupCheckboxLabel() {
        mediaImageView.addSubview(_checkboxLabel)
        
        //x,y,w,h
        _checkboxLabel.rightAnchor.constraint(equalTo: _checkbox.rightAnchor).isActive = true
        _checkboxLabel.bottomAnchor.constraint(equalTo: _checkbox.topAnchor, constant: -1).isActive = true
    }
    
}

// MARK: - Selectors

extension SecondCameraViewController {
    
    func sendMedia() {
        (UIApplication.shared.delegate as! AppDelegate).checkLocality {
            AuthService.validateUser {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { 
                        return 
                    }
                    
                    if let image = strongSelf.mediaImageView.image {
                        strongSelf.postToStorage(image: image, storageRef: DataService.instance.mediaStorageRef, uid: NSUUID().uuidString)
                    }
                    strongSelf.mediaImageView.isHidden = true
                    strongSelf.mediaImageView.image = nil
                }
            }
        }
    }
    
}

// MARK: - CameraDelegate

extension SecondCameraViewController: CameraDelegate {
    
    func setupMediaView() {
        setupSendButton()
        setupCheckbox()
        setupCheckboxLabel()
    }
    
    func triggerCheckbox() {
        _checkbox.isChecked = true
    }
    
    func handleCheckbox(isHidden: Bool) {
        _checkbox.isHidden = isHidden
        _checkboxLabel.isHidden = isHidden
    }
}

// MARK: - ImageUploading

extension SecondCameraViewController: ImageUploading {
    
    func postToDB(imageUrl: String, uid: String) {
        if let currentUser = AuthService.currentUser {
            let media: [String: AnyObject] = ["userId" : currentUser.uid as AnyObject,
                                              "imageUrl" : imageUrl as AnyObject,
                                              "latitude" : (isHidden ? nil : _locationManager?.location?.coordinate.latitude) as AnyObject,
                                              "longitude" : (isHidden ? nil : _locationManager?.location?.coordinate.longitude) as AnyObject,
                                              "timestamp" : FIRServerValue.timestamp() as AnyObject]
            
            _shared.mediaRef.childByAutoId().setValue(media) { (error, reference) in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { 
                        return
                    }
                    
                    if let _ = error {
                        strongSelf.createAlertWithOkAction(title: ERROR, message: SOMETHING_WENT_WRONG)
                    }
                }
            }
        }
    }
    
}

// MARK: - ApplicationDelegate

extension SecondCameraViewController: ApplicationDelegate {
    
    func handleAlert() {
        createAlertWithOkAction(title: WRONG_LOCATION_TITLE, message: WRONG_LOCATION_MESSAGE)
    }
    
    func handleError(message: String) {
        createAlertWithOkAction(title: ERROR, message: message)
    }
    
}

// MARK: - CheckboxDelegate

extension SecondCameraViewController: CheckboxDelegate {
    
    func check() {
        _locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
        _locationManager?.startUpdatingLocation()
    }
    
    func unCheck() {
        _locationManager?.stopUpdatingLocation()
        _locationManager = nil
    }
    
}
