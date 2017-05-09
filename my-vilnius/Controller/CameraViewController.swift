//
//  CameraViewController.swift
//  my-vilnius
//
//  Created by Rokas on 05/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import CameraEngine
import Firebase
import UIKit

@objc protocol CameraDelegate {
    
    @objc optional func setupCameraView(view: UIView)
    @objc optional func handleCheckbox(isHidden: Bool)
    @objc optional func triggerCheckbox()
    func setupMediaView()
    
}

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    private var _tabController: UITabBarController?
    fileprivate var _delegate: CameraDelegate?
    fileprivate var _isHidden = false
    fileprivate var _cameraEngine = CameraEngine()
    
    fileprivate lazy var _flashButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "flash_off"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(triggerFlash), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _switchCamerasButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "switch_cameras"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(triggerSwitchCameras), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _imagePickerButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "image_picker"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(triggerImagePick), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _cameraButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(triggerCamera), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _dismissButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "dismiss"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissImageView), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _saveButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "save"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveMedia), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _mediaImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    var mediaImageView: UIImageView {
        return _mediaImageView
    }
    
    var isHidden: Bool {
        return _isHidden
    } 	
    
    var tabController: UITabBarController? {
        get { return _tabController }
        set { _tabController = newValue }
    }
    
    var delegate: CameraDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        _cameraEngine.flashMode = .off
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _cameraEngine.startSession()
        _tabController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _cameraEngine.stopSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layer = self._cameraEngine.previewLayer else {
            return
        }
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
        view.layer.masksToBounds = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupFlashButton()
        setupSwitchCamerasButton()
        setupImagePickerButton()
        setupCameraButton()
        _delegate?.setupCameraView?(view: view)
        setupOutterMediaImageView()
        setupDismissButton()
        setupSaveButton()
        _delegate?.setupMediaView()
    }
    
}

// MARK: - SetupUI

extension CameraViewController {
    
    fileprivate func setupFlashButton() {
        view.addSubview(_flashButton)
        
        //x,y,w,h
        _flashButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -HEIGHT_003).isActive = true
        _flashButton.topAnchor.constraint(equalTo: view.topAnchor, constant: HEIGHT_0045).isActive = true
        _flashButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _flashButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    fileprivate func setupSwitchCamerasButton() {
        view.addSubview(_switchCamerasButton)
        
        //x,y,w,h
        _switchCamerasButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -HEIGHT_003).isActive = true
        _switchCamerasButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -HEIGHT_003).isActive = true
        _switchCamerasButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _switchCamerasButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    fileprivate func setupImagePickerButton() {
        view.addSubview(_imagePickerButton)
        
        //x,y,w,h
        _imagePickerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: HEIGHT_003).isActive = true
        _imagePickerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -HEIGHT_003).isActive = true
        _imagePickerButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _imagePickerButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    fileprivate func setupCameraButton() {
        view.addSubview(_cameraButton)
        
        //x,y,w,h
        _cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        _cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -HEIGHT_003).isActive = true
        _cameraButton.heightAnchor.constraint(equalToConstant: HEIGHT_015).isActive = true
        _cameraButton.widthAnchor.constraint(equalToConstant: HEIGHT_015).isActive = true
    }
    
    fileprivate func setupOutterMediaImageView() {
        view.addSubview(_mediaImageView)
        
        //x,y,w,h
        _mediaImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        _mediaImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        _mediaImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        _mediaImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        _mediaImageView.isHidden = true
    }
    
    fileprivate func setupDismissButton() {
        _mediaImageView.addSubview(_dismissButton)
        
        //x,y,w,h
        _dismissButton.leftAnchor.constraint(equalTo: _mediaImageView.leftAnchor, constant: HEIGHT_003).isActive = true
        _dismissButton.topAnchor.constraint(equalTo: _mediaImageView.topAnchor, constant: HEIGHT_0045).isActive = true
        _dismissButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _dismissButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    fileprivate func setupSaveButton() {
        _mediaImageView.addSubview(_saveButton)
        
        //x,y,w,h
        _saveButton.leftAnchor.constraint(equalTo: _mediaImageView.leftAnchor, constant: HEIGHT_003).isActive = true
        _saveButton.bottomAnchor.constraint(equalTo: _mediaImageView.bottomAnchor, constant: -HEIGHT_003).isActive = true
        _saveButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _saveButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    
    
}

// MARK: - Selectors

extension CameraViewController {
    
    func triggerFlash() {
        switch _cameraEngine.flashMode! {
        case .off:
            _cameraEngine.flashMode = .on
            _flashButton.setImage(UIImage(named: "flash_on"), for: .normal)
            break
        case .on:
            _cameraEngine.flashMode = .off
            _flashButton.setImage(UIImage(named: "flash_off"), for: .normal)
            break
        default:
            break
        }
        
    }
    
    func triggerSwitchCameras() {
        _cameraEngine.switchCurrentDevice()
    }
    
    func triggerImagePick() {
        handleSelectedImageView()
    }
    
    func triggerCamera() {
        _cameraEngine.capturePhoto { (image , error) -> (Void) in
            DispatchQueue.main.async{ [weak self] in
                guard let strongSelf = self else { 
                    return 
                }
                
                if let image = image {
                    if strongSelf._cameraEngine.isBackCamera {
                        strongSelf._mediaImageView.image = image
                    } else {
                        strongSelf._mediaImageView.image = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .leftMirrored)
                    }
                    
                    strongSelf._mediaImageView.isHidden = false
                    strongSelf._isHidden = false
                    strongSelf._delegate?.triggerCheckbox?()
                    strongSelf._delegate?.handleCheckbox?(isHidden: strongSelf._isHidden)
                }
            }
        }
    }
    
    func dismissImageView() {
        _mediaImageView.isHidden = true
        _mediaImageView.image = nil
    }
    
    func saveMedia() {
        savePhoto(image: _mediaImageView.image)
    }
    
}

// MARK: - ImagePicking

extension CameraViewController: ImagePicking {
    
    func setImage(image: UIImage) {
        _mediaImageView.image = image
        _mediaImageView.isHidden = false
    }
    
    func handleSelectedImageView() {
        createImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        imagePickerController(image: image)
        
        _isHidden = true
        
        if let handleCheckbox = _delegate?.handleCheckbox?(isHidden: _isHidden) {
            handleCheckbox
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerControllerDidCancel()
    }
    
}

// MARK: - SavingPhoto

extension CameraViewController: SavingPhoto {}

