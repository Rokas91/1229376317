//
//  ProfileViewController.swift
//  my-vilnius
//
//  Created by Rokas on 08/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import SwiftKeychainWrapper
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate var _firstCameraViewController: FirstCameraViewController?
    
    fileprivate lazy var _scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    fileprivate lazy var _containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate lazy var _logoutButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        
        return button
    }()
    
    fileprivate lazy var _profileImageView: CircleImageView = {
        let imageView = CircleImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToFirstCameraViewController)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    fileprivate lazy var _emailField: UILabel = {
        let label = UILabel()
        
        label.textColor = .customGreen
        label.font = .avenir
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    fileprivate lazy var _userNameField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.returnKeyType = .done
        
        return textField
    }()
    
    fileprivate lazy var _resetPasswordButton: RoundedButton = {
        let button = RoundedButton()
        
        button.backgroundColor = .customGreen
        button.setTitle(RESET_PASSWORD, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        return button
    }()
    
    var firstCameraViewController: FirstCameraViewController? {
        get { return _firstCameraViewController }
        set { _firstCameraViewController = newValue }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _userNameField.delegate = self
        setupUI()
        
        DataService.instance.getCurrentUserData { userData in
            DispatchQueue.main.async{ [weak self] in
                guard let strongSelf = self else {
                    return 
                }
                
                guard let userData = userData else {
                    return
                }
                
                strongSelf._profileImageView.loadImageUsingCacheWithUrlString(userData["imageUrl"] as! String)
                strongSelf._emailField.text = (userData["email"] as! String)
                strongSelf._userNameField.text = (userData["userName"] as! String)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _firstCameraViewController?.firstCameraDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupScrollView()
        setupContainerView()
        setupLogoutButton()
        setupProfileImageView()
        setupEmailField()
        setupUserNameField()
        setupResetPassword()
    }
    
}

// MARK: - Selectors

extension ProfileViewController {
    
    func logOut() {
        let yesAction = UIAlertAction(title: YES, style: .default, handler: { action in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
                print("ID removed from keychain \(keychainResult)")

                do {
                    try FIRAuth.auth()?.signOut()
                } catch {
                    strongSelf.createAlertWithOkAction(title: ERROR, message: SOMETHING_WENT_WRONG)
                }
                
                strongSelf.createAlertWithOkAction(title: SHUT_DOWN_WARNING, handler: { action in
                    exit(0)
                })
            }
        })
        
        let noAction = UIAlertAction(title: NO, style: .default)
        
        createAlert(title: WARNING, message: SIGN_OUT_MESSAGE, actions: yesAction, noAction)
    }
    
    func goToFirstCameraViewController() {
        if let firstCameraViewController = _firstCameraViewController {
            present(firstCameraViewController, animated: true)
        }
    }
    
    func resetPassword() {
        AuthService.validateUser {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return 
                }
                let yesAction = UIAlertAction(title: YES, style: .default, handler: { action in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {
                            return 
                        }
                        if let email = AuthService.currentUser?.email {
                            FIRAuth.auth()!.sendPasswordReset(withEmail: email) { error in
                                strongSelf.createAlertWithOkAction(title: PASSWORD_RESET_TITLE, message: "\(PASSWORD_RESET_MESSAGE) \(email)")
                            }
                        } else {
                            strongSelf.createAlertWithOkAction(title: ERROR, message: SOMETHING_WENT_WRONG)
                        }
                    }
                })
                
                let noAction = UIAlertAction(title: NO, style: .default)
                
                strongSelf.createAlert(title: WARNING, message: PASSWORD_RESET_CONFIRMATION, actions: yesAction, noAction)
            }
        }
    }
    
}

// MARK: - SetupUI

extension ProfileViewController {
    
    fileprivate func setupScrollView() {
        view.addSubview(_scrollView)
        
        //x,y,w,h
        _scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        _scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        _scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        _scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate func setupContainerView() {
        _scrollView.addSubview(_containerView)
        
        //x,y,w,h
        _containerView.leftAnchor.constraint(equalTo: _scrollView.leftAnchor).isActive = true
        _containerView.rightAnchor.constraint(equalTo: _scrollView.rightAnchor).isActive = true
        _containerView.topAnchor.constraint(equalTo: _scrollView.topAnchor).isActive = true
        _containerView.bottomAnchor.constraint(equalTo: _scrollView.bottomAnchor).isActive = true
        _containerView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        _containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    fileprivate func setupLogoutButton() {
        _containerView.addSubview(_logoutButton)
        
        //x,y,w,h
        _logoutButton.rightAnchor.constraint(equalTo: _containerView.rightAnchor, constant: -HEIGHT_003).isActive = true
        _logoutButton.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: HEIGHT_0045).isActive = true
        _logoutButton.heightAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
        _logoutButton.widthAnchor.constraint(equalToConstant: HEIGHT_0075).isActive = true
    }
    
    fileprivate func setupProfileImageView() {
        _containerView.addSubview(_profileImageView)
        
        //x,y,w,h
        _profileImageView.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: HEIGHT_01).isActive = true
        _profileImageView.centerXAnchor.constraint(equalTo: _containerView.centerXAnchor).isActive = true
        _profileImageView.widthAnchor.constraint(equalToConstant: WIDTH_065).isActive = true
        _profileImageView.heightAnchor.constraint(equalToConstant: WIDTH_065).isActive = true
    }
    
    fileprivate func setupEmailField() {
        _containerView.addSubview(_emailField)
        
        //x,y,w,h
        _emailField.topAnchor.constraint(equalTo: _profileImageView.bottomAnchor, constant: HEIGHT_015).isActive = true
        _emailField.leftAnchor.constraint(equalTo: _containerView.leftAnchor, constant: HEIGHT_003 + 10).isActive = true
        _emailField.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _emailField.heightAnchor.constraint(equalToConstant: HEIGHT_003).isActive = true
    }
    
    fileprivate func setupUserNameField() {
        _containerView.addSubview(_userNameField)
        
        //x,y,w,h
        _userNameField.topAnchor.constraint(equalTo: _emailField.bottomAnchor, constant: HEIGHT_003).isActive = true
        _userNameField.leftAnchor.constraint(equalTo: _containerView.leftAnchor, constant: HEIGHT_003).isActive = true
        _userNameField.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _userNameField.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }

    fileprivate func setupResetPassword() {
        _containerView.addSubview(_resetPasswordButton)
        
        //x,y,w,h
        _resetPasswordButton.topAnchor.constraint(equalTo: _userNameField.bottomAnchor, constant: HEIGHT_003).isActive = true
        _resetPasswordButton.leftAnchor.constraint(equalTo: _containerView.leftAnchor, constant: HEIGHT_003).isActive = true
        _resetPasswordButton.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _resetPasswordButton.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
}

// MARK: - KeyboardNotification

extension ProfileViewController: KeyboardHandling {
    
    func keyboardIsOn(keyboardSize: CGSize) {
        _scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height - 90), animated: true)
        _profileImageView.isHidden = true
        _resetPasswordButton.isHidden = true
        _logoutButton.isHidden = true
    }
    
    func keyboardIsOff() {
        _scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        _scrollView.isScrollEnabled = false
        _profileImageView.isHidden = false
        _resetPasswordButton.isHidden = false
        _logoutButton.isHidden = false
    }
    
}

// MARK: - FirstCameraViewControllerDelegate

extension ProfileViewController: FirstCameraViewControllerDelegate {
    
    func setImage(image: UIImage) {
        _profileImageView.image = image
        if let currentUser = AuthService.currentUser {
            postToStorage(image: image, storageRef: DataService.instance.usersStorageRef, uid: currentUser.uid)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty {
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderColor = UIColor.customGreen.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            DataService.instance.currentUserRef?.updateChildValues(["userName" : text as AnyObject])
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= 25
    }
    
}

// MARK: - ImageUploading

extension ProfileViewController: ImageUploading {
    
    func postToDB(imageUrl: String, uid: String) {
        DataService.instance.currentUserRef?.updateChildValues(["imageUrl" : imageUrl as AnyObject])
    }
    
}

// MARK: - Alerting

extension ProfileViewController: Alerting {}
