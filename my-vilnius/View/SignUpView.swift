//
//  SignUpView.swift
//  my-vilnius
//
//  Created by Rokas on 05/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol SignUpViewDelegate {
    
    func signUp(userNameField: UITextField, emailField: UITextField, passwordField: UITextField, confirmPasswordField: UITextField)
    
}

class SignUpView: UIView {
    
    // MARK: - Properties
    
    fileprivate var _delegate: SignUpViewDelegate?
    
    fileprivate lazy var _userNameField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.tag = 0
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ENTER_USERNAME
        textField.returnKeyType = .next
        
        return textField
    }()
    
    fileprivate lazy var _emailField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.tag = 1
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ENTER_EMAIL
        textField.returnKeyType = .next
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    fileprivate lazy var _passwordField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.tag = 2
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ENTER_PASSWORD
        textField.returnKeyType = .next
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    fileprivate lazy var _confirmPasswordField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.tag = 3
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = CONFIRM_PASSWORD
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    fileprivate lazy var _signUpButton: RoundedButton = {
        let button = RoundedButton()
        
        button.setTitle(SIGN_UP, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        return button
    }()
    
    var delegate: SignUpViewDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    var signUpButton: RoundedButton {
        return _signUpButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        setupUserNameField()
        setupEmailField()
        setupPasswordField()
        setupConfirmPasswordField()
        setupSignUpButton()
    }
}

// MARK: - Selectors

extension SignUpView {
    
    func signUp() {
        _delegate?.signUp(userNameField: _userNameField, emailField: _emailField, passwordField: _passwordField, confirmPasswordField: _confirmPasswordField)                                              
    }
    
}

// MARK: - SetupUI

extension SignUpView {
    
    fileprivate func setupUserNameField() {
        addSubview(_userNameField)
        
        //x,y,w,h
        _userNameField.topAnchor.constraint(equalTo: topAnchor, constant: HEIGHT_003).isActive = true
        _userNameField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _userNameField.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _userNameField.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
    fileprivate func setupEmailField() {
        addSubview(_emailField)
        
        //x,y,w,h
        _emailField.topAnchor.constraint(equalTo: _userNameField.bottomAnchor, constant: HEIGHT_003).isActive = true
        _emailField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _emailField.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _emailField.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
    fileprivate func setupPasswordField() {
        addSubview(_passwordField)
        
        //x,y,w,h
        _passwordField.topAnchor.constraint(equalTo: _emailField.bottomAnchor, constant: HEIGHT_003).isActive = true
        _passwordField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _passwordField.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _passwordField.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
    fileprivate func setupConfirmPasswordField() {
        addSubview(_confirmPasswordField)
        
        //x,y,w,h
        _confirmPasswordField.topAnchor.constraint(equalTo: _passwordField.bottomAnchor, constant: HEIGHT_003).isActive = true
        _confirmPasswordField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _confirmPasswordField.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _confirmPasswordField.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
    fileprivate func setupSignUpButton() {
        addSubview(_signUpButton)
        
        //x,y,w,h
        _signUpButton.topAnchor.constraint(equalTo: _confirmPasswordField.bottomAnchor, constant: HEIGHT_003).isActive = true
        _signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _signUpButton.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _signUpButton.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
}

// MARK: - UITextFieldDelegate

extension SignUpView: UITextFieldDelegate  {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            _emailField.becomeFirstResponder()
            break
        case 1:
            _passwordField.becomeFirstResponder()
            break
        case 2:
            _confirmPasswordField.becomeFirstResponder()
            break
        case 3:
            _confirmPasswordField.resignFirstResponder()
            break
        default:
            break
        }
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0:
            let currentString = textField.text! as NSString
            let newString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= 25
        default:
            return true
        }
    }
    
}

























