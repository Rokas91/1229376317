//
//  LoginView.swift
//  my-vilnius
//
//  Created by Rokas on 05/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol LoginViewDelegate {
    
    func login(emailField: UITextField, passwordField: UITextField)
    func goToForgotPassswordViewController()
    
}


class LoginView: UIView {
    
    // MARK: - Properties
    
    fileprivate var _delegate: LoginViewDelegate?
    
    fileprivate lazy var _emailField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.tag = 0
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ENTER_EMAIL
        textField.returnKeyType = .next
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    fileprivate lazy var _passwordField: RoundedTextField = {
        let textField = RoundedTextField()
        
        textField.tag = 1
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ENTER_PASSWORD
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    fileprivate lazy var _loginButton: RoundedButton = {
        let button = RoundedButton()
        
        button.setTitle(LOGIN, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _forgotPasswordButton: UIButton = {
        let button = UIButton()

        button.setTitle(FORGOT_PASSWORD, for: .normal)
        button.setTitleColor(.customGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToForggotPassswordViewController), for: .touchUpInside)
        
        return button
    }()
    
    var delegate: LoginViewDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    var loginButton: RoundedButton {
        return _loginButton
    }
    
    var forgotPasswordButton: UIButton {
        return _forgotPasswordButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    private func setupUI() {
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
        setupForgotPasswordButton()
    }
}

// MARK: - Selectors

extension LoginView {
    
    func login() {
        _delegate?.login(emailField: _emailField, passwordField: _passwordField)
    }
    
    func goToForggotPassswordViewController() {
        _delegate?.goToForgotPassswordViewController()
    }
    
}

// MARK: - SetupUI

extension LoginView {
    
    fileprivate func setupEmailField() {
        addSubview(_emailField)

        //x,y,w,h
        _emailField.topAnchor.constraint(equalTo: topAnchor, constant: HEIGHT_007).isActive = true
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
    
    fileprivate func setupLoginButton() {
        addSubview(_loginButton)
        
        //x,y,w,h
        _loginButton.topAnchor.constraint(equalTo: _passwordField.bottomAnchor, constant: HEIGHT_007).isActive = true
        _loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _loginButton.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _loginButton.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
    fileprivate func setupForgotPasswordButton() {
        addSubview(_forgotPasswordButton)
        
        //x,y,w,h
        _forgotPasswordButton.topAnchor.constraint(equalTo: _loginButton.bottomAnchor, constant: HEIGHT_003).isActive = true
        _forgotPasswordButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _forgotPasswordButton.widthAnchor.constraint(equalToConstant: WIDTH_07).isActive = true
        _forgotPasswordButton.heightAnchor.constraint(equalToConstant: HEIGHT_0065).isActive = true
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate  {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            _passwordField.becomeFirstResponder()
            break
        case 1:
            _passwordField.resignFirstResponder()
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
    
}
