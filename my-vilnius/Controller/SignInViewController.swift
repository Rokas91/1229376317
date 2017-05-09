//
//  SignInViewController.swift
//  my-vilnius
//
//  Created by Rokas on 05/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import SwiftKeychainWrapper
import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    private var _mainTabBarController: MainTabBarController?
    fileprivate var _imageSelected = false
    fileprivate var _shared = AuthService.instance
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
    
    fileprivate lazy var _logoImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    fileprivate lazy var _profileImageView: CircleImageView = {
        let imageView = CircleImageView()
        
        imageView.image = UIImage(named: "add_user")
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.customGreen.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToFirstCameraViewController)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    fileprivate lazy var _segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Sign up"])
        let width = self.view.frame.width
        let height = self.view.frame.height
        let x = width * 0.05
        let y = height * 0.45
        let segmentHeight = height * 0.055
        let attributedSegmentFont = NSDictionary(object: UIFont.avenir(size: segmentHeight * 0.5), forKey: NSFontAttributeName as NSCopying)
        
        segmentedControl.frame = CGRect(x: x, y: y, width: width - 2 * x, height: segmentHeight)
        segmentedControl.tintColor = .customGreen
        segmentedControl.setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        
        return segmentedControl
    }()
    
    fileprivate lazy var _loginView: LoginView = {
        let view = LoginView()
        
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    fileprivate lazy var _signUpView: SignUpView = {
        let view = SignUpView()
        
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var firstCameraViewController: FirstCameraViewController? {
        get { return _firstCameraViewController }
        set { _firstCameraViewController = newValue }
    }
    
    var mainTabBarController: MainTabBarController? {
        get { return _mainTabBarController }
        set { _mainTabBarController = newValue }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedValueChanged(_segmentedControl)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _shared.delegate = self
        _firstCameraViewController?.firstCameraDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID), let mainTabBarController = _mainTabBarController {
            present(mainTabBarController, animated: true)
        }
        
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func completeSignIn(id: String) {
        _ = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        if let mainTabBarController = _mainTabBarController {
            present(mainTabBarController, animated: true)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupScrollView()
        setupContainerView()
        setupLogoImageView()
        setupProfileImageView()
        _containerView.addSubview(_segmentedControl)
        setupLoginView()
        setupSignUpView()
    }
    
}

// MARK: - Selectors

extension SignInViewController {
    
    func segmentedValueChanged(_ sender: UISegmentedControl) {
        let isLoginView = sender.selectedSegmentIndex == 0
        
        UIView.animate(withDuration: 0.3, animations: {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                strongSelf._loginView.alpha = isLoginView ? 1 : 0
                strongSelf._signUpView.alpha = isLoginView ? 0 : 1
                strongSelf._logoImageView.isHidden = !isLoginView
                strongSelf._profileImageView.isHidden = isLoginView
            }
        })
    }
    
    func goToFirstCameraViewController() {
        if let firstCameraViewController = _firstCameraViewController {
            present(firstCameraViewController, animated: true)
        }
    }
    
}

// MARK: - SetupUI

extension SignInViewController {
    
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
    
    fileprivate func setupLogoImageView() {
        _containerView.addSubview(_logoImageView)
        
        //x,y,w,h
        _logoImageView.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: HEIGHT_0075).isActive = true
        _logoImageView.centerXAnchor.constraint(equalTo: _containerView.centerXAnchor).isActive = true
        _logoImageView.widthAnchor.constraint(equalToConstant: WIDTH_05).isActive = true
        _logoImageView.heightAnchor.constraint(equalToConstant: WIDTH_05).isActive = true
    }
    
    fileprivate func setupProfileImageView() {
        _containerView.addSubview(_profileImageView)
        
        //x,y,w,h
        _profileImageView.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: HEIGHT_0075).isActive = true
        _profileImageView.centerXAnchor.constraint(equalTo: _containerView.centerXAnchor).isActive = true
        _profileImageView.widthAnchor.constraint(equalToConstant: WIDTH_055).isActive = true
        _profileImageView.heightAnchor.constraint(equalToConstant: WIDTH_055).isActive = true
    }
    
    fileprivate func setupLoginView() {
        _containerView.addSubview(_loginView)
        
        //x,y,w,h
        _loginView.leftAnchor.constraint(equalTo: _containerView.leftAnchor).isActive = true
        _loginView.rightAnchor.constraint(equalTo: _containerView.rightAnchor).isActive = true
        _loginView.topAnchor.constraint(equalTo: _segmentedControl.bottomAnchor, constant: 1).isActive = true
        _loginView.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupSignUpView() {
        _containerView.addSubview(_signUpView)
        
        //x,y,w,h
        _signUpView.leftAnchor.constraint(equalTo: _containerView.leftAnchor).isActive = true
        _signUpView.rightAnchor.constraint(equalTo: _containerView.rightAnchor).isActive = true
        _signUpView.topAnchor.constraint(equalTo: _segmentedControl.bottomAnchor, constant: 1).isActive = true
        _signUpView.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor).isActive = true
    }
    
}

// MARK: - KeyboardNotification

extension SignInViewController: KeyboardHandling {
    
    func keyboardIsOn(keyboardSize: CGSize) {
        _scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height - view.frame.height * 0.05), animated: true)
        _logoImageView.isHidden = true
        _profileImageView.isHidden = true
        _segmentedControl.isHidden = true
        _loginView.loginButton.isHidden = true
        _loginView.forgotPasswordButton.isHidden = true
        _signUpView.signUpButton.isHidden = true
    }
    
    func keyboardIsOff() {
        _scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        _scrollView.isScrollEnabled = false
        _logoImageView.isHidden = !(_segmentedControl.selectedSegmentIndex == 0)
        _profileImageView.isHidden = _segmentedControl.selectedSegmentIndex == 0
        _segmentedControl.isHidden = false
        _loginView.loginButton.isHidden = false
        _loginView.forgotPasswordButton.isHidden = false
        _signUpView.signUpButton.isHidden = false
    }
    
}

// MARK: - LoginViewDelegate

extension SignInViewController: LoginViewDelegate {
    
    func login(emailField: UITextField, passwordField: UITextField) {
        guard let email = emailField.text, email.characters.count > 0 else {
            createDismissingAlert(title: EMAIL_EMPTY_MESSAGE)
            return
        }
        
        guard let password = passwordField.text, password.characters.count > 0 else {
            createDismissingAlert(title: PASSWORD_EMPTY_MESSAGE)
            return
        }
        
        _shared.login(email: email, password: password, onComplete: { (errMsg, user) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                guard errMsg == nil else {
                    strongSelf.createAlertWithOkAction(title: AUTHENTICATION_ERROR_TITLE, message: errMsg!)
                    return
                }
                
                if let user = user {
                    strongSelf.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    func goToForgotPassswordViewController() {
        let forgotPasswordViewController = UINavigationController(rootViewController: ForgotPasswordViewController())
        present(forgotPasswordViewController, animated: true)
    }
    
}

// MARK: - SignUpViewDelegate

extension SignInViewController: SignUpViewDelegate {
    
    func signUp(userNameField: UITextField, emailField: UITextField, passwordField: UITextField, confirmPasswordField: UITextField) {
        guard let userName = userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), userName.characters.count > 0 else {
            createDismissingAlert(title: USER_EMPTY_MESSAGE)
            return
        }
        
        guard let email = emailField.text, email.characters.count > 0 else {
            createDismissingAlert(title: EMAIL_EMPTY_MESSAGE)
            return
        }
        
        guard let password = passwordField.text, password.characters.count > 0 else {
            createDismissingAlert(title: PASSWORD_EMPTY_MESSAGE)
            return
        }
        
        guard let confirmPassword = confirmPasswordField.text, confirmPassword.characters.count > 0 else {
            createDismissingAlert(title: CONFIRM_PASSWORD_EMPTY_MESSAGE)
            return
        }
        
        guard passwordField.text == confirmPasswordField.text else {
            createDismissingAlert(title: PASSWORDS_NOT_MATCH_MESSAGE)
            return
        }
        
        guard let profileImage = _profileImageView.image, _imageSelected else {
            _profileImageView.layer.borderColor = UIColor.red.cgColor
            createDismissingAlert(title: PROFILE_IMAGE_EMPTY_MESSAGE)
            return
        }
        
        let acceptAction = UIAlertAction(title: ACCEPT, style: .default, handler: { action in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return
                }
                
                strongSelf._shared.createUser(userName: userName, email: email.lowercased(), password: password, profileImage: profileImage, onComplete: { (errMsg, user) in
                    
                    guard errMsg == nil else {
                        strongSelf.createAlertWithOkAction(title: AUTHENTICATION_ERROR_TITLE, message: errMsg!)
                        return
                    }
                    
                    if let user = user {
                        strongSelf.completeSignIn(id: user.uid)
                    }
                })
            }
        })
        
        let notAcceptAction = UIAlertAction(title: NOT_ACCEPT, style: .default)
        
        createAlert(title: AGREEMENT, message: AGREEMENT_STATE, actions: acceptAction, notAcceptAction)
    }
    
}

// MARK: - FirstCameraViewControllerDelegate

extension SignInViewController: FirstCameraViewControllerDelegate {
    
    func setImage(image: UIImage) {
        _profileImageView.layer.borderWidth = 0
        _profileImageView.image = image
        _imageSelected = true
    }
    
}


// MARK: - Alerting

extension SignInViewController: Alerting {}

// MARK: - AuthServiceDelegate

extension SignInViewController: AuthServiceDelegate {
    
    func handleSendingError(email: String?) {
        if let email = email {
            createAlertWithOkAction(title: "There were some problems while sending email verification to \(email), please try again")
        }
    }
    
    func handleSentEmailVerification(email: String?) {
        if let email = email {
            createAlertWithOkAction(title: "Email verification was sent to \(email), after your email is verified you can log in")
        }
    }
    
    func handleNotVerifiedEmail(email: String?) {
        if let email = email {
            createAlertWithOkAction(title: "Your email is not verified, link to verify it was sent to \(email)")
        }
    }
    
    func handleSetValueError() {
        createAlertWithOkAction(title: ERROR, message: SOMETHING_WENT_WRONG)
    }
    
}
