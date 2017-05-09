//
//  ForggotPasswordViewController.swift
//  my-vilnius
//
//  Created by Rokas on 08/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate lazy var _navigationBarHeight: CGFloat = {
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            return navigationBarHeight
        }
        
        return 40
    }()
    
    private lazy var _backButton: UIBarButtonItem = {
        let backButton = UIBarButtonItem(image: UIImage(named: "back")?.resizeImage(newHeight: self._navigationBarHeight * 0.6), style: .plain, target: self, action: #selector(goBack))
        
        return backButton
    }()
    
    fileprivate lazy var _emailField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ENTER_EMAIL
        textField.delegate = self
        textField.returnKeyType = .done
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    fileprivate lazy var _resetPasswordButton: RoundedButton = {
        let button = RoundedButton()
        
        button.backgroundColor = .customGreen
        button.setTitle(SEND_PASSWORD, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func handleFirebaseError(error: NSError) {
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .errorCodeInvalidEmail:
                createAlertWithOkAction(title: INVALID_EMAIL_ERROR)
                break
            default:
                break
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = _backButton
        setupEmailField()
        setupResetPasswordButton()
    }

}

// MARK: - Selectors

extension ForgotPasswordViewController {

    func resetPassword() {
        guard let email = _emailField.text else {
            return
        }
        
        guard !email.isEmpty else {
            createDismissingAlert(title: ENTER_EMAIL)
            return
        }
        
        FIRAuth.auth()!.sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                self.handleFirebaseError(error: error! as NSError)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { 
                    return 
                }
                strongSelf.createAlertWithOkAction(title: PASSWORD_RESET_TITLE, message: "\(PASSWORD_RESET_MESSAGE) \(email)")
            }
        }
    }
    
    func goBack() {
        dismiss(animated: true)
    }
    
}

// MARK: - SetupUI

extension ForgotPasswordViewController {
    
    private var width07: CGFloat {
        return CGFloat.width * 0.7
    }
    
    private var height0065: CGFloat {
        return CGFloat.height * 0.065
    }
    
    private var top007: CGFloat {
        return CGFloat.height * 0.07
    }
    
    private var top02: CGFloat {
        return CGFloat.height * 0.2
    }
    
    fileprivate func setupEmailField() {
        view.addSubview(_emailField)
        
        //x,y,w,h
        _emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: top02).isActive = true
        _emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        _emailField.widthAnchor.constraint(equalToConstant: width07).isActive = true
        _emailField.heightAnchor.constraint(equalToConstant: height0065).isActive = true
    }
    
    fileprivate func setupResetPasswordButton() {
        view.addSubview(_resetPasswordButton)
        
        //x,y,w,h
        _resetPasswordButton.topAnchor.constraint(equalTo: _emailField.bottomAnchor, constant: top007).isActive = true
        _resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        _resetPasswordButton.widthAnchor.constraint(equalToConstant: width07).isActive = true
        _resetPasswordButton.heightAnchor.constraint(equalToConstant: height0065).isActive = true
    }
    
}


// MARK: - KeyboardNotification

extension ForgotPasswordViewController: KeyboardHandling {
    
    func keyboardIsOn(keyboardSize: CGSize) {
        _resetPasswordButton.isHidden = true
    }
    
    func keyboardIsOff() {
        _resetPasswordButton.isHidden = false
    }
    
}

// MARK: - UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate  {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _emailField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let placeholder = textField.placeholder {
            (textField as? RoundedTextField)?.placeholderValue = placeholder
            textField.placeholder = nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            textField.placeholder = (textField as? RoundedTextField)?.placeholderValue
        }
    }
    
}

// MARK: - Alerting

extension ForgotPasswordViewController: Alerting {}









